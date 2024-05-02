class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "b1b0a6c692771a4e37f7ff33490365f8f330660a4110adf650b2483d99379c1d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f7d9f451f58bdd81fd12625aec2659465812008f652ffdc6a061aee2316e4ad"
    sha256 cellar: :any,                 arm64_ventura:  "26e545bde3fed76d919b3b6676546866767895ee368d35e4c585476a7a232047"
    sha256 cellar: :any,                 arm64_monterey: "c40c8e6652ae0f41b640db62540a45a69db2c3f086aba084168c12f62af40d9d"
    sha256 cellar: :any,                 sonoma:         "07bafb3a94d39284a5325adcb298d0fa9a9ef36abe3a7f4d6d13643770f655a2"
    sha256 cellar: :any,                 ventura:        "cee8fa01738480d146e375cacd9c6ef6bd376e3035c312ea04e4cfb8b854aa23"
    sha256 cellar: :any,                 monterey:       "ff3b7cdf8065b37b30a85577d7a7b5421f5dec6b0d9faf64c6e383e780048331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9bc95c84a868adb57cf7d27649a10b65bcbc217909831ffdb0024a37575abdb"
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
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
