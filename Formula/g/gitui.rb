class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.24.2.tar.gz"
  sha256 "f8a0a4b3117a40d5fcfe29618d350027bebe3fbcee39f0aef85cb9a5325453b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f5a157b13a4622f5f0d0fd7ea2c8bed10bba8cfc015bb2ee16365b969448572"
    sha256 cellar: :any,                 arm64_monterey: "675cb4d71f7ec254d65315287190404e153d8e3d13f46b53d11c1651ab6dcaa5"
    sha256 cellar: :any,                 arm64_big_sur:  "bb3e406c8feca8d997b8ff753c81682ac391faf468931a37bcd4c71779b1014a"
    sha256 cellar: :any,                 ventura:        "4de0657db433a9691ee616a2456f70562ae6b940554c6ff37a529eabb3282b4c"
    sha256 cellar: :any,                 monterey:       "947f2be64c833f4621637f2b694def0c9f1a43ec9ecfdfaa8ac0c7ae21a033ec"
    sha256 cellar: :any,                 big_sur:        "1b22854c392f2e9ba8a4359b341c17b639616e2f18ada23e9d717c2ae83b3193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a70a03088d8454b959ff8334508ffd0daa43e45d65c74efbbf1e85cf6921d69"
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
