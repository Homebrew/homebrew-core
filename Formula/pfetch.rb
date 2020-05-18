class Pfetch < Formula
  desc "Pretty system information tool written in POSIX sh"
  homepage "https://github.com/dylanaraps/pfetch/"
  url "https://github.com/dylanaraps/pfetch/archive/0.6.0.tar.gz"
  sha256 "d1f611e61c1f8ae55bd14f8f6054d06fcb9a2d973095367c1626842db66b3182"
  head "https://github.com/dylanaraps/pfetch.git"

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
