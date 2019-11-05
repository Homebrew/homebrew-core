class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.66.6.tar.gz"
  sha256 "adcbfb02ab7fe040b5b89702c6a45c1d228bf9c9d5933f09882a3a1903688c91"

  bottle do
    sha256 "7c7b21f846b7586a8ed06866f6939487c6a417c8531bb4d3dc29e111ec3e0e94" => :catalina
    sha256 "04ad58200f70361c19d776ed0cf86afe8944723aeacc71c1a7e85ff1ab9c3331" => :mojave
    sha256 "42adeb14ac00945e38ad1400172a538fb6ded0d622f9aa0f44e55168a4f0c2eb" => :high_sierra
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
