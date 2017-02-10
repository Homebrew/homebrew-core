class Nsnake < Formula
  desc "Classic snake game with textual interface"
  homepage "http://nsnake.alexdantas.net/"
  url "https://downloads.sourceforge.net/project/nsnake/GNU-Linux/nsnake-3.0.1.tar.gz"
  sha256 "e0a39e0e188a6a8502cb9fc05de3fa83dd4d61072c5b93a182136d1bccd39bb9"
  head "https://github.com/alexdantas/nSnake.git"

  bottle do
    sha256 "b1de1091630f4e16fc2e0767801034fc9e81618888035ab7dbc17bb3a0082d83" => :sierra
    sha256 "ea456b15c9edb91530c56e0f0f1da78aef138eb4805cfd083a7fdf9e3579c36d" => :el_capitan
    sha256 "bb902bc64d9028e4d2341eed665809c77e7e4bb6fb614309111962c1e46c8c17" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # No need for Linux desktop
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"pixmaps").rmtree
  end

  test do
    assert_match /nsnake v#{version} /, shell_output("#{bin}/nsnake -v")
  end
end
