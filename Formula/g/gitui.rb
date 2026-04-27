class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/gitui-org/gitui"
  url "https://github.com/gitui-org/gitui/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "0400cbf59605490b5fb8779f9af41fa4d7a1bb748093ca0e13156a5dff31c7aa"
  license "MIT"
  head "https://github.com/gitui-org/gitui.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d680002eec562dc3e551b65df13870ed7c76f12137a47bd797b50bdcd2487d1"
    sha256 cellar: :any,                 arm64_sequoia: "7cecc7faf77b0a9eb8263cf9bcbc9ac6c9066eafb065b4c6e43188572b9c3061"
    sha256 cellar: :any,                 arm64_sonoma:  "e4370bb36e12fd616f29ccd1159abe412e3196b3e8d758fdd1b6c04069d63cdd"
    sha256 cellar: :any,                 sonoma:        "a257d6363277574277a79ac33ec5ce1c9d97531b5137d4ef00d3fac4dd7793f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b81e6514a38501028d2e54c7d245ac376f2f5f6039e0f1b96ca1bafd5cc9fc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3776e0418c6233796021596efb33de72343bfd36f67c562c347642598d52253"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
