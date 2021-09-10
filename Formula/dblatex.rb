class Dblatex < Formula
  desc "Transform DocBook XML to LaTeX"
  homepage "https://dblatex.sourceforge.io"
  url "https://files.pythonhosted.org/packages/a8/1c/a07b54389399ac0c014c175936eb142f562468c607150a2df3e94d365611/dblatex-0.3.10.tar.bz2"
  sha256 "56fee45ef3c242c4800bad20c5aeb934b31ba0894bdf86275b60b2e7b2f4cb8e"
  license "GPL-2.0-or-later"

  depends_on "imagemagick"

  def install
    ENV.append_path "PATH", "/Library/TeX/texbin"
    system "/usr/bin/python", "setup.py", "install", "--prefix=#{prefix}"
    inreplace bin/"dblatex", "#!/usr/bin/env python", "#!/usr/bin/python"
  end

  test do
    system bin/"dblatex", "-v"
  end
end
