class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.24.3.tar.gz"
  sha256 "a5fc6b52a4db0037c3351b9743af49c8bb9ccff4dda5bdb064bab9e59f68fde2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c1d3e0f13419a058c3e5634fae152513ff5ef0b413037d4be38e579f9ad9bc3"
    sha256 cellar: :any,                 arm64_monterey: "367eeda857726379cc53f0279ce04f9aaca2de6129bab1221d88f4d8c8240348"
    sha256 cellar: :any,                 arm64_big_sur:  "a0c27c3c2e8a69bc1d9253e7498e37f9dd568a12c3958af5235cbd77542782e9"
    sha256 cellar: :any,                 ventura:        "306d806daf9d1a1c229e7927c0453a45ecca4cec8fd280f26b45eadc518145f1"
    sha256 cellar: :any,                 monterey:       "ed0cdd39146ae050f79f933cd2023f3415646bf8520920c2a6d9a301526f432e"
    sha256 cellar: :any,                 big_sur:        "b44fc0ad42cdb69b323422f55a2c950cf66f7d2562163ca49df56e2c9809fbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbabb6ee576993edf714abc9d2f7505a486ceaeec503dd927f43c2e08bf31a56"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
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
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
