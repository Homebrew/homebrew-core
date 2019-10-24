class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.65.0.tar.gz"
  sha256 "f3e9c60d16fb9ea8961138ea4645e3b1fb18b8040df37f20d8ec30f3ce9f7633"

  bottle do
    sha256 "d5b1496b84052b732ed2fb33914ab13c860995e090d81a4b8659555e4b0cbc47" => :catalina
    sha256 "a000fc47764b04f74c0f3795a9118987651065ceff81be1a7e53a1d707e3403d" => :mojave
    sha256 "e7df3761c818f4bf63c531f9c2cb2d38b0fcaeaed1a9948a996d10a789e2f65f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", ".[all]"
    # NOTE: dvc depends on asciimatics, which depends on Pillow, which
    # uses liblcms2.2.dylib that causes troubles on mojave. See [1]
    # and [2] for more info. As a workaround, we need to simply
    # uninstall Pillow.
    #
    # [1] https://github.com/peterbrittain/asciimatics/issues/95
    # [2] https://github.com/iterative/homebrew-dvc/issues/9
    system libexec/"bin/pip", "uninstall", "-y", "Pillow"
    system libexec/"bin/pip", "uninstall", "-y", "dvc"
    venv.pip_install_and_link buildpath

    bash_completion.install "scripts/completion/dvc.bash" => "dvc"
    zsh_completion.install "scripts/completion/dvc.zsh"
  end

  test do
    system "#{bin}/dvc", "--version"
  end
end
