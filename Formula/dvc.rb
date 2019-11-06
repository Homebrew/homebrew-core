class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.66.9.tar.gz"
  sha256 "cac859495206c65c88d7e8c94219dcc248ac6ba223a06df3560844cb5febd18b"

  bottle do
    sha256 "6be539847bc62c359d3406f2dc3e692911fc6a5bc1bb947784c621bc6331c251" => :catalina
    sha256 "3f27fda4403e4b273b8696f51fcf7cd41a5d2a8771a42087e6274f0f052433e6" => :mojave
    sha256 "d5f973332f8fed94e77531debd39a9a3ff760308977f3f49e8dff8c065ccdf7e" => :high_sierra
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
