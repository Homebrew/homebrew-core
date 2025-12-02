class Mussh < Formula
  desc "Multi-host SSH wrapper"
  homepage "https://mussh.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mussh/mussh/1.0/mussh-1.0.tgz"
  sha256 "6ba883cfaacc3f54c2643e8790556ff7b17da73c9e0d4e18346a51791fedd267"
  license "GPL-1.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2aef0306d0c39460009d42553effebd0aca77dd7c76489323e13f95ecd76b17e"
  end

  def install
    bin.install "mussh"
    man1.install "mussh.1"
  end

  test do
    system bin/"mussh", "--help"
  end
end
