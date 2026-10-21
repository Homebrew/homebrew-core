class CustomInstall < Formula
  include Language::Python::Virtualenv

  desc "Install CIA files directly to Nintendo 3DS SD card"
  homepage "https://github.com/ihaveamac/custom-install"
  url "https://github.com/ihaveamac/custom-install/archive/refs/tags/v2.1.tar.gz"
  sha256 "35477355c8981d7aa55ace60fc3e43e1f96f762d141cf8773eb22df1ce4c50f8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8338987a49846f2e8ff2ad2fcc9bf05b974d70390c0087dfe020546f90dcd095"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1751ec07d4fa27a5901732441e40dce9eefa3f7713d49af856d4298fce30de26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5819da05de97b54df7001bf27d413193d08c39e1d5543f6766651aa15c6b0e71"
    sha256 cellar: :any,                 arm64_linux:       "1ff3446b6a1837392440452dfa55e397741ead9ec0b0d560e176626fb03c49d1"
    sha256 cellar: :any,                 x86_64_linux:      "6fa5a9f8f36b35d7fbfdac9b640c07df77c024b17862e1929481410eed63e365"
  end

  depends_on "python@3.15"
  depends_on "save3ds_fuse"

  resource "events" do
    url "https://files.pythonhosted.org/packages/f6/2b/b92ae30db60cb3c2043da3b72abf30158c92cc77922280b45e9edf36bbf8/Events-0.4.tar.gz"
    sha256 "01d9dd2a061f908d74a89fa5c8f07baa694f02a2a5974983663faaf7a97180f5"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyctr" do
    url "https://files.pythonhosted.org/packages/f5/8e/e586fff15921fbc0f7f35750bfcc621c88f02790006fe29cb7b5155414e3/pyctr-0.6.0.tar.gz"
    sha256 "d3994c72c21e2481c8dcbc074138ebe0cf9b9f5146f8642c72e1aadf85f18caf"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    inreplace "custominstall.py",
              "save3ds_fuse_path = join(script_dir, 'bin', platform, 'save3ds_fuse')",
              "save3ds_fuse_path = '#{formula_opt_bin("save3ds_fuse")}/save3ds_fuse'"
    libexec.install "custominstall.py"
    (bin/"custom-install").write <<~BASH
      #!/bin/bash
      exec "#{libexec}/bin/python3" "#{libexec}/custominstall.py" "$@"
    BASH
  end

  test do
    assert_match "the following arguments are required:", shell_output("#{bin}/custom-install 2>&1", 2)

    touch testpath/"boot9.bin"
    output = shell_output("#{bin}/custom-install -b boot9.bin -m s1.sed --sd #{testpath}/tmp f1.cia f2.cia 2>&1", 1)
    assert_match "BootromNotFoundError", output
  end
end
