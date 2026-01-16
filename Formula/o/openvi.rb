class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.7.32.tar.gz"
  sha256 "3378f371b7446708b5d909dcbf8608a74d771f2660f06014888da2163a77af81"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f9f98c1766d28f774755c5504a4e0009aa9075d0810dac96a43f670543d0836"
    sha256 cellar: :any,                 arm64_sequoia: "21592b330f84b246945cb28063a11879f1eefe50df87ac000693362cc6cbe882"
    sha256 cellar: :any,                 arm64_sonoma:  "812ae5e06f44b6adccb233053f542332536be62b4d4dcb6d75c52aa4636ec213"
    sha256 cellar: :any,                 sonoma:        "ab51a0599172f446d17f61bf0a1c93816100854d58bf6875fb1ae1635d97d662"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72b16c18985eafe024d7cfe55047850f7e36375d0ca6aa42e84f2dc0b701eb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070f50496b0c46cc89f50bc2884e227658778557f745a8f061cdebfe5e2c94a0"
  end

  depends_on "pkgconf" => :build
  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CURSESLIB=-lncurses", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
