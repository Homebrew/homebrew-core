class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "5a67d526e22533952a747cb34eb2430a1340dd3139f60a785f579bba4a6aa5ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09779802d7e5a8be04545ce8f67237b59cb9b3f9ce435102e76f71075c5a29b6"
    sha256 cellar: :any,                 arm64_ventura:  "38b410b0db8a331c7bd032b2194337fe7cc37b7e41bf086839409f9478bf3c6c"
    sha256 cellar: :any,                 arm64_monterey: "e10e695ec296f452c7c4e4607573accbc326ffa048b6c1b817d1d54843434b6f"
    sha256 cellar: :any,                 sonoma:         "1a3254a64360681b008722a192e8071c2c4d37483cda136a623f98d075ae3a35"
    sha256 cellar: :any,                 ventura:        "44d3b5227758adcb2def4db8003e97ced7377f4972e9c30abe8c412b2bc0ffbd"
    sha256 cellar: :any,                 monterey:       "72736375b4d0d0a2515627786cf46412e9aacb3d06cb29298da5f6edc8ceace3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3edd12eeb36faef2259e3ca293a6e2ebd874a40ee8088a7629c68f3b795e5579"
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
