class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.67.0.tar.gz"
  sha256 "fa02b646d328a9693e320b428307266789b2fdd24d0d5e47babe8aef6b432ea4"

  bottle do
    sha256 "cdf9146f302a79921c95968e3bb3cc88e3dfe18474fc28f43e3e472ca3c643ed" => :catalina
    sha256 "00d8faea2f677a87e5fefba4c6ca9da7b6ad3c8b41644c5bdf93cfbb8188c8be" => :mojave
    sha256 "3174020731aefb8f1435adb22282db8afa72f7e907579731226658d1b3c0198f" => :high_sierra
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
