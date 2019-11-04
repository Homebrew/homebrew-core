class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.66.4.tar.gz"
  sha256 "a30dd28be335cc45cdbcb9c9a6ae3dd9f77810c77aed945b8ad1671f53cc46c1"

  bottle do
    sha256 "0fa86e3c8cd8cda435e46dbbe9256e4dde6bb9860ba7c96187cdcd82d1a3bc3e" => :catalina
    sha256 "50327d46d3e0a4ef2273682451bc2fe5c52a9ce93b371a5775977e4164821cfc" => :mojave
    sha256 "2e5b1faa079963cf2eb8c8eb3c7cb7bb0f534116d3660b7ece86bf4ba154f291" => :high_sierra
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
