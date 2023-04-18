class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.3.22.tar.gz"
  sha256 "9599fde001d9df93c4f463e6ccbd66e28ad0d992db4f306ff987053fcfecb005"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f894e01fdb7a047315d5e6a422aa1aeb4acafb454114cdd1172c07f8188a635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3260577671347848d7ae895bccf4d37e50c87b5b719c8aeeca748e155e132cec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05db65ae4d0a12400bab7a24209729aa6909ce0d5b677144757f7e3540a599e3"
    sha256 cellar: :any_skip_relocation, ventura:        "dafdfcf7c75b5f2415a17b20c58b9dee807b60f12c254baf9eee07f322b48181"
    sha256 cellar: :any_skip_relocation, monterey:       "a1630b29eef6fc04f405ddd71ff66cf16e9f1e4994fb53cb5f0967bc41e87fba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f08251912ecab3d1bf6c5243e156c3416485f843900fa51e9252b583b640711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9a9ab5613559a584838bc9cf416d71462edea6e6de7ec4778f36b7cf4279ca"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
