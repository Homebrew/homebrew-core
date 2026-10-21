class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/gitui-org/gitui"
  url "https://github.com/gitui-org/gitui/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "0400cbf59605490b5fb8779f9af41fa4d7a1bb748093ca0e13156a5dff31c7aa"
  license "MIT"
  head "https://github.com/gitui-org/gitui.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ff655d56ccaba70f91c1f39cb9d9f6079996a1a1662dca8e9c3a15001d23b301"
    sha256 cellar: :any, arm64_tahoe:       "03b806fe1fb1cdbcf4c4c48336c4c9ee42a2730c1704b4d301d14798d9f2d0f8"
    sha256 cellar: :any, arm64_sequoia:     "bd0885766dec6b2e63098b1792bd1a534a29e955f1c0305ee14cb72a164897f6"
    sha256 cellar: :any, arm64_linux:       "f7ba6917232ad2e0751491b7d409c59d46407f5acb0d7f7ad57d7a3998a126db"
    sha256 cellar: :any, x86_64_linux:      "04114993bd07bb6a696c3f3e145935398a29eb398ef7fd42e64db60ad147152f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat" => :build # for libz-sys
  end

  # Apply open dependabot PR to update openssl-sys for OpenSSL 4 support
  patch do
    url "https://github.com/gitui-org/gitui/commit/f0cbe33cd72951c0faf877ac1531d3af8ba66d2a.patch?full_index=1"
    sha256 "5c75d06ce71366b575a8a7189d6f767833d630f028b4854b8307415d9ed83fd8"
    type :unofficial
    resolves "https://github.com/gitui-org/gitui/pull/2914"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "utils/linkage"

    system "git", "clone", "https://github.com/gitui-org/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    output_log = testpath/"output.log"
    cmd_env = { "LC_CTYPE" => "en_US.UTF-8", "LANG" => "en_US.UTF-8", "TERM" => "xterm" }
    PTY.spawn(cmd_env, bin/"gitui", "-d", "gitui", [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      sleep 2
      # select log tab
      w.puts "2"
      sleep 2
      # inspect commit (return + right arrow key)
      w.puts "\r"
      sleep 2
      w.puts "\e[C"
      sleep 2
    ensure
      r.close
      w.close
      Process.kill "TERM", pid
      Process.wait pid
    end

    screenlog = output_log.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog

    linked_libraries = [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
