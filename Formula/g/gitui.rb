class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "5a67d526e22533952a747cb34eb2430a1340dd3139f60a785f579bba4a6aa5ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "739b2fba0c482453e418c38bf674da8f00054e4e8412b2c737ca6407997ad46c"
    sha256 cellar: :any,                 arm64_ventura:  "3a7356e4a448cd9ee2986afefd9c723aa6d0feee32d89a510a069827a0af8ffd"
    sha256 cellar: :any,                 arm64_monterey: "9b4d1a6d8cf11c5514ee8e124c87a3a17d9f2c229a1bb2bc55e0d30fcf1ea3ce"
    sha256 cellar: :any,                 sonoma:         "983efec7318c06c7ba48eb96c24aaf09ed695cbb2ebdb077cd507b6b8a2de8cd"
    sha256 cellar: :any,                 ventura:        "fff8c764bb0bf530206a1d2b841570250f8d4fe00589c1ebdf57892e12cc8375"
    sha256 cellar: :any,                 monterey:       "826d5404ce4c99ca5083b769109c538f34b253c5fc00fc99e394cfc94ffb752d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6cb3c5cd29861e448b4fa09fa4db387f1a12334d689ab91aa02c7212a06bd5"
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
