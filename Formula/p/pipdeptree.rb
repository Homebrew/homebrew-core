class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/9b/e6/ccebfbb786e3804446ec35e336e5ebcb91e8f5a50e193e04eba8d74c11b2/pipdeptree-2.25.0.tar.gz"
  sha256 "029bcdcbd2e0130ec33b222c7833b8b5e52f674760dcf2df40b4ae6ff007a74f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48f0ef115694b6916120a89ad2dc2cbffec26bb2ca104f64ac691c9c89c2d9a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48f0ef115694b6916120a89ad2dc2cbffec26bb2ca104f64ac691c9c89c2d9a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48f0ef115694b6916120a89ad2dc2cbffec26bb2ca104f64ac691c9c89c2d9a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb63199d2b749836e54b4bcc5ec8c97f827c22ca8ef32333f9a642b16ad3c55a"
    sha256 cellar: :any_skip_relocation, ventura:       "bb63199d2b749836e54b4bcc5ec8c97f827c22ca8ef32333f9a642b16ad3c55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f0ef115694b6916120a89ad2dc2cbffec26bb2ca104f64ac691c9c89c2d9a3"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
