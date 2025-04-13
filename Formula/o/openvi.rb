class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.6.31.tar.gz"
  sha256 "75ef62fd882d8a18e388509f5fe4eca6b241f3286f6121e2bcbea65ec592ae11"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7782e6ed0969f0329395994ababca79b94ea7a8e576b97cdb71ec6698f070e45"
    sha256 cellar: :any,                 arm64_sonoma:  "3516b1e080308c873e3d03a050a07f0e0515abe4baa306cd9bc8a838371a7d1f"
    sha256 cellar: :any,                 arm64_ventura: "51f83e5960cdae0f320dd3d9c84b0130c454bf30f834b196c0ad204d979b4b13"
    sha256 cellar: :any,                 sonoma:        "bb4fcc6193748bca32f6d5994ac0d03305a1656ebca9ab146cffe8f2d0efbe10"
    sha256 cellar: :any,                 ventura:       "a8f35299f732a8d44488d8dbfdcdcc697f4b2e3e0c26e3b9c20d0a00a01ede58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "639cbb47ed0bfba8d0a0623d0a8b2cc804408088169992779c42c09d74d78206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec194a9a4049c4c7ae786e494072d97261b1d0865661819796668caa2ad893be"
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
