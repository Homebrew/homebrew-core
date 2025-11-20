class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/gitui-org/gitui"
  license "MIT"
  head "https://github.com/gitui-org/gitui.git", branch: "master"

  stable do
    url "https://github.com/gitui-org/gitui/archive/refs/tags/v0.27.0.tar.gz"
    sha256 "55a85f4a3ce97712b618575aa80f3c15ea4004d554e8899669910d7fb4ff6e4b"

    # Backport fix for newer Rust
    patch do
      url "https://github.com/gitui-org/gitui/commit/950e703cab1dd37e3d02e7316ec99cc0dc70513c.patch?full_index=1"
      sha256 "4e473d73b112a35dd95ba4f379b56cc2bae7e5d142bd5013798ef36f32b65dd0"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc550a583861402d6a679bacbe09d1da462689495584a8b0f8972e74809d131e"
    sha256 cellar: :any,                 arm64_sequoia: "2b153db2c3519ec2f197cd128b34732ec2e2b90355d7f05e46629853060e5a9d"
    sha256 cellar: :any,                 arm64_sonoma:  "f5eae626dfbdd29bf9a00bb67f070a08d85b95f1affdae32adc0ba8f9851019a"
    sha256 cellar: :any,                 arm64_ventura: "911bfd33ff0f35e6f39dd2ae4b472fb2bc42cc51aa378c2b0d4a4280f6cf103a"
    sha256 cellar: :any,                 sonoma:        "c734edd0329e21b2d5f08cc847f9780eed6eb51e27e029d807270f140ef4e22e"
    sha256 cellar: :any,                 ventura:       "031988daf2b09dee6f249501354de183538753578d99fc61432da8ba77df4384"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb2397cc161b3efcd5b6b7957d607ca1102ad158117f0c3f8358b4134c6e6b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f54255b0500c4831f812986017344dcfd8c7a971a994de024e945df3f4c886"
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
