class Mussh < Formula
  desc "Multi-host SSH wrapper"
  homepage "https://mussh.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mussh/mussh/1.0/mussh-1.0.tgz"
  sha256 "6ba883cfaacc3f54c2643e8790556ff7b17da73c9e0d4e18346a51791fedd267"
  license "GPL-1.0-or-later"

  bottle do
    rebuild 1
    manifest_sha256 "d0d027b08f0a3aba41ae603364be7231d6817b3f354e157175dc6257c080fe36"
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
