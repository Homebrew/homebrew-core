class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https://fortls.fortran-lang.org/"
  url "https://files.pythonhosted.org/packages/f1/82/b0f91372538de824bccb5e4fe8936e47f6771dbd700a74d35e19045050b5/fortls-3.1.2.tar.gz"
  sha256 "93ea78598492ac699f7cefb624e89bf5012d44604d07fbe5ad4a31e32fc977bc"
  license "MIT"
  head "https://github.com/fortran-lang/fortls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d05b52850e35b539f838e07367814c387a1b0dd801687028875c752130489539"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d05b52850e35b539f838e07367814c387a1b0dd801687028875c752130489539"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d05b52850e35b539f838e07367814c387a1b0dd801687028875c752130489539"
    sha256 cellar: :any_skip_relocation, sonoma:         "d05b52850e35b539f838e07367814c387a1b0dd801687028875c752130489539"
    sha256 cellar: :any_skip_relocation, ventura:        "d05b52850e35b539f838e07367814c387a1b0dd801687028875c752130489539"
    sha256 cellar: :any_skip_relocation, monterey:       "d05b52850e35b539f838e07367814c387a1b0dd801687028875c752130489539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "361fa9e20b1acd15bd76e155b7cb7314172ae820431c4ebacba1fc985d4f1aac"
  end

  depends_on "python@3.12"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https://files.pythonhosted.org/packages/91/59/51b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbc/json5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  def install
    virtualenv_install_with_resources

    # Disable automatic update check
    (bin/"fortls").unlink
    (bin/"fortls").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/python3 -m fortls --disable_autoupdate "$@"
    EOS
  end

  test do
    system bin/"fortls", "--help"
    (testpath/"test.f90").write <<~EOS
      program main
      end program main
    EOS
    system bin/"fortls", "--debug_filepath", testpath/"test.f90", "--debug_symbols", "--debug_full_result"
  end
end
