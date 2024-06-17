class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.5.29.tar.gz"
  sha256 "3be3eff39561ea5b2edd5e2883a8d9c32e2ba8d999bfdb9fb77c85c8cbd65d4c"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bef581722715b0623333ce952d97101af9cee85b242affb1962cdf6c29568b3"
    sha256 cellar: :any,                 arm64_ventura:  "e4166622c59476eeae8c62392a4c9d774d83320b56a2e332e92492bd0997e91d"
    sha256 cellar: :any,                 arm64_monterey: "3336c1d08bf7bcc8eb17934cddcc378c6ced58b08e4ed51eb52a0988a6002317"
    sha256 cellar: :any,                 sonoma:         "3f0e38ad3d57c2fb7705c2e2ab4838c5ffdde36bdf520fed8ddfd5cdedd02955"
    sha256 cellar: :any,                 ventura:        "de9079fcc430c57ffd6bb5221f8fc42e989e9ba88ba40b84cc0aa74020e4af7d"
    sha256 cellar: :any,                 monterey:       "3d6d07e7f259896f28b5458ee58453d808c9b192a01555440f99e7db0de388f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb2d2887df0b007137773ac437f93117ea09463a03d65fa4d604fa7946c978f"
  end

  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
