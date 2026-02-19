class Libtar < Formula
  desc "C library for manipulating POSIX tar files"
  homepage "https://repo.or.cz/libtar.git"
  url "https://repo.or.cz/libtar.git",
      tag:      "v1.2.20",
      revision: "0907a9034eaf2a57e8e4a9439f793f3f05d446cd"
  license "NCSA"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "23ceb454b2f6611082364f55c92c573111df507f73b3d19ca69555bc4ebac48a"
    sha256 cellar: :any,                 arm64_sequoia: "d4e8e07ef8f56b82f2770a4b7dbbe05b1e82fd2c79bd96e7fd951a9122ed960a"
    sha256 cellar: :any,                 arm64_sonoma:  "98e649e4ddedb2869148b221f35a5a2cebe6f03482ae073518454d34e2779421"
    sha256 cellar: :any,                 sonoma:        "6f63b617e34b6a198feafb7330800d8a47960cf2bdcd412cc1bcdad98fb07108"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cfe7b8ddcc43ac4ff3271b9bcc59589799c70700ad2a231f8ee645213aa8e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d636db798faefdeba582d4b33c6ee41f659a46c7e99cd9b5aab9eb4af1b10b37"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "This is a simple example"
    system "tar", "-cvf", "test.tar", "homebrew.txt"
    rm "homebrew.txt"
    refute_path_exists testpath/"homebrew.txt"
    assert_path_exists testpath/"test.tar"

    system bin/"libtar", "-x", "test.tar"
    assert_path_exists testpath/"homebrew.txt"
  end
end
