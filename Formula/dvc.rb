class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.66.11.tar.gz"
  sha256 "a6c97075e242b310d310d7f8ae24bf1af7c66e3dafc8e6a248af2c5a5c1a9d68"

  bottle do
    sha256 "5e92b3d972d4430383aaaf6b7f16ac8b3ef2db61fe5fe3a6e8b96db32394539b" => :catalina
    sha256 "97cf3c8040e7de6d13fa87101b0b280f47ed694b9ae2a6343a0abed646f281c3" => :mojave
    sha256 "b73d233fa1434e2e5abb73ba5c9f9bf9be8e0b5b84a58206a6e67dbfb9604f47" => :high_sierra
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
