class Pfetch < Formula
  desc "Pretty system information tool written in POSIX sh"
  homepage "https://github.com/dylanaraps/pfetch/"
  url "https://github.com/dylanaraps/pfetch/archive/0.6.0.tar.gz"
  sha256 "d1f611e61c1f8ae55bd14f8f6054d06fcb9a2d973095367c1626842db66b3182"
  license "MIT"
  head "https://github.com/dylanaraps/pfetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e5ceb26959ab4f137221f87eefe0ba1912695cce887b30f2e4894c699d86261" => :big_sur
    sha256 "d3d84a024e20f9a85803389150748894f9a9dab94593af5c0ee3967a82ebe55a" => :arm64_big_sur
    sha256 "f93914feee7f4e3cda77341c3bddf2cf51eb4b2aed01f6ace771db75078da570" => :catalina
    sha256 "f93914feee7f4e3cda77341c3bddf2cf51eb4b2aed01f6ace771db75078da570" => :mojave
    sha256 "f93914feee7f4e3cda77341c3bddf2cf51eb4b2aed01f6ace771db75078da570" => :high_sierra
  end

  def install
    if build.head?
      bin.mkdir
      inreplace "Makefile", "install -Dm", "install -m"
      system "make", "install", "PREFIX=#{prefix}"
    else
      bin.install "pfetch"
    end
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
