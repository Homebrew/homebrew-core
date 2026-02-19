class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/gitui-org/gitui"
  url "https://github.com/gitui-org/gitui/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "3d7d1deef84b8cb3f59882b57b9a70d39ddd6491bd4539504d69b2b3924c044f"
  license "MIT"
  head "https://github.com/gitui-org/gitui.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3bf06c89899c36b3f312246fe1e2638fec683b7d21cb4b230071980a126be480"
    sha256 cellar: :any,                 arm64_sequoia: "2eca639c9b02860faca96ca14ac7758fb18360138d0b8d260fc606efb27461b6"
    sha256 cellar: :any,                 arm64_sonoma:  "210ee535561366f07bd0f9a8a6ed589c857997c954f1bb63ab92ec40a3f0fce2"
    sha256 cellar: :any,                 sonoma:        "c5b29d634487cbed56de2c817401da5755ef13d7a31123666d5a0481b1a60988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf71424e3d0d7ed2c46366864891f447697e1037c7178f7a2f219be7477a505d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e53d035e90f92966f561ee6ceb697aea0722a5fe7933fa47867bf24b2c02e879"
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
