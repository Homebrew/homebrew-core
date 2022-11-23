class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.1.18.tar.gz"
  sha256 "39c4ac933f52c65021be06fcece8bfd308fc1ac08e8ff4604b2fdd1994192d08"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d59ba7d4d87901fd50e67305abbd2a3def4762847f6b46bd6991563ad457662"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68a83e1767c703456c42fe3d38bf5a5cf08e622537256003ec8c9c7f44611955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76464fed80b2e93c767b08ed47b4991f16c857545f093d681ec025cd0bd25c49"
    sha256 cellar: :any_skip_relocation, ventura:        "e70b5e8e4b1cff525bb3228c79953d29a5f728859ff0ff47f59fc6fcf261f2cf"
    sha256 cellar: :any_skip_relocation, monterey:       "bd6559fef495dbd7446aa9cb76bb221d1cd72993847b322829374fdba5147469"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c63fcf5ff9f608c3d4d340b2ab95406fdbc8992ce48ef28e0d3f6b6406c129a"
    sha256 cellar: :any_skip_relocation, catalina:       "1ca47aec6c65d18713fe17e5ac604fa7aa0a70e904d24b3e69e5fb5581003bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc37583e49ea8d1bf3c546902daf6a416918b29295912e6a5bfb8c6f2e56f31"
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
