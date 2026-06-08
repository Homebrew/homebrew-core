class CustomInstall < Formula
  include Language::Python::Virtualenv

  desc "Install CIA files directly to Nintendo 3DS SD card"
  homepage "https://github.com/ihaveamac/custom-install"
  url "https://github.com/ihaveamac/custom-install/archive/refs/tags/v2.1.tar.gz"
  sha256 "35477355c8981d7aa55ace60fc3e43e1f96f762d141cf8773eb22df1ce4c50f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61a022ea5b0f415929d32b8cb527f0772b065da9084df4feb3ea606bee39db83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcfb60764dc38a009ee05ea94148df24426e920a89a432d96c3da69bfeb1b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52459657c539c5094957b985437531219f6e19282ed8c4c693040609a7bc4a5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ce576ef08e7769e5f95e2062b928ecdc07b87550426eeb50645738d091105b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0877be59f541572b6a19f107bbbbf8490cff0ce865e54715cbe22c782ddc1e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37d6e1c136e15b4627953afc2c8baa93736bb7f170df4a6ba56255e9b9f8eeb"
  end

  depends_on "python@3.14"
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
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    inreplace "custominstall.py",
              "save3ds_fuse_path = join(script_dir, 'bin', platform, 'save3ds_fuse')",
              "save3ds_fuse_path = '#{Formula["save3ds_fuse"].opt_bin}/save3ds_fuse'"
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
