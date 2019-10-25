class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.65.0.tar.gz"
  sha256 "f3e9c60d16fb9ea8961138ea4645e3b1fb18b8040df37f20d8ec30f3ce9f7633"

  bottle do
    sha256 "04705c00aadb5d07c15e0b0a76fc7f1375cac07af8ba7528467a498d18f8b2d0" => :catalina
    sha256 "88a5f22867279f561c10a530280bf1f1dcb7fc201a444182e11f2a86fe90ed8e" => :mojave
    sha256 "2350dafadaf30c9827240f29470090c28bf6fa66be4a69d6160e52653a214893" => :high_sierra
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
