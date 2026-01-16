class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/gitui-org/gitui"
  url "https://github.com/gitui-org/gitui/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "3d7d1deef84b8cb3f59882b57b9a70d39ddd6491bd4539504d69b2b3924c044f"
  license "MIT"
  head "https://github.com/gitui-org/gitui.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8bc1cc8b7f6e1be0d218a19325f24ff4a15335c962fb93d37961b357a830ac8"
    sha256 cellar: :any,                 arm64_sequoia: "273adf03fc2aa1ee541d35b69c298767b510443e2812ce4b3d9c13a3b8cabdbc"
    sha256 cellar: :any,                 arm64_sonoma:  "4c5d3a04099ab24147b5124576dc41c7457e2bb37b4836e2563a9c1a6cde9981"
    sha256 cellar: :any,                 sonoma:        "ff77e89525eb25480940d3ea1aa6e09b52e28078ec7c3790ba138a82da63debd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3daaff36fa113c13e951f4355534ca1fa28018177c337062fe53dec32c9cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b88c6afc765f0870e184e93921a0a52019d876b579111c97fd6f4d5e3f5a67"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    system "git", "clone", "https://github.com/gitui-org/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 2
    # select log tab
    input.puts "2"
    sleep 2
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 2
    input.puts "\e[C"
    sleep 2
    input.close

    screenlog = (testpath/"screenlog.ansi").read
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
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
