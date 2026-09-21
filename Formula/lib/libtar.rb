class Libtar < Formula
  desc "C library for manipulating POSIX tar files"
  homepage "https://repo.or.cz/libtar.git"
  url "https://repo.or.cz/libtar.git",
      tag:      "v1.2.20",
      revision: "0907a9034eaf2a57e8e4a9439f793f3f05d446cd"
  license "NCSA"

  bottle do
    rebuild 4
    sha256 cellar: :any, arm64_golden_gate: "0bee5a7daf113533848ee50ebd90c8c966850ae12540f09f7b441b6a8d1fd9ab"
    sha256 cellar: :any, arm64_tahoe:       "1ee318fdf6d06e8d670cedcd4e9d5a8df008104c3fdc2aaace8caa3ec04ea0f8"
    sha256 cellar: :any, arm64_sequoia:     "48ccf141f62ae2175f39795d088a23af7d984d5fa226c5ff0accd8fe051a9136"
    sha256 cellar: :any, arm64_linux:       "d800d4b33d612c482798f24145fc941409e8c86878f0a1cb71346fb42c430cd5"
    sha256 cellar: :any, x86_64_linux:      "8fc74cf7b1dd61a1e8ea1b18e090e678ddef84672dce29ee39295d1fc536e60d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # K&R function definitions in `compat/` are invalid in the C23 default that autoconf 2.73 picks
    ENV["ac_cv_prog_cc_c23"] = "no"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "This is a simple example"
    # bsdtar's default pax format adds extended headers for macOS xattrs, which libtar cannot read
    system "tar", "--format=ustar", "-cvf", "test.tar", "homebrew.txt"
    rm "homebrew.txt"
    refute_path_exists testpath/"homebrew.txt"
    assert_path_exists testpath/"test.tar"

    system bin/"libtar", "-x", "test.tar"
    assert_path_exists testpath/"homebrew.txt"
  end
end
