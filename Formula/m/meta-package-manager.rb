class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/43/e6/ea650344bb8ff68dc85b0303b2e10db97b67727d0c595b4289a63ed4d7f6/meta_package_manager-8.3.0.tar.gz"
  sha256 "dd06527de24f718ab141a37b920b88c3018f205175fbecf5f50a712008d5f606"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/meta-package-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "176b14991329b037ec0fccaf96272aff8a49dd0cf66c38b67a51034dae0f34dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ed8d80ae9cf65958d023cd1ab9af94ce78ba41f987e5c7c05321778639a1b54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05b3cc11dafe7e44426f06e23e36a023f2f0d4686404f054ead5333d8c84815f"
    sha256 cellar: :any,                 arm64_linux:       "b8548be82c2c12f63a9aaa7cd2bc623c32f31cf5342c4f21ab4b078e114e268d"
    sha256 cellar: :any,                 x86_64_linux:      "d9dde8b61977e9fdd64f4c01665386e2f7c14fe0a742b0dc95ddc48e2a8c7f09"
  end

  depends_on "rust" => :build

  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: ["certifi", "rpds-py"]

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/2d/1f/b7ce2efe406b87bb3693d587b91bcd8fa9030888870ceff29e4a0d233cb2/bracex-3.2.2.tar.gz"
    sha256 "d18976160b3ba01a57d5c53a5c8c3aa2506efa9e0a3a62467251f82b8f563fde"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/de/5e/db9986517ce10c38bb224b24f18f64bf6061effc295a2c28fc1569843bcd/click_extra-10.2.0.tar.gz"
    sha256 "499b8ad73f9fa9182f799fbb14ebbc7e61a6dde9c2977954173fdcef4b32994e"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/05/e2/d41446c6195eff0db3b671ddb202e39f42f9ea7c0dd15cd43fbf5cf0d7f7/cloup-4.0.0.tar.gz"
    sha256 "83b0870ee863bcc85129e40e1b208bcfdebe4cd2142e9ce1d0daf7d276cab038"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/99/37/5c2fde6d7c6036fd53144e63b37d8632314f791f3d681d3fcf0456d06292/extra_platforms-14.0.1.tar.gz"
    sha256 "c58c5cb5dab87ee907b977be403ed2fa2e923bdc27bd39c76c6b60c99ea0700c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/2e/17/bf44790f97414e37885830139933b4e96faac71560768ae9f9e458dbd936/wcmatch-12.0.1.tar.gz"
    sha256 "4ea6acef75b657bf71ac8fa9520165bf5ae55120c4e655895a5b7d4c69896c5e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  def install
    rewrite_shebang detected_python_shebang, "meta_package_manager/bar_plugin.py"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mpm", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpm --version")

    # Check mpm is detecting brew and report it as a manager in a table row.
    assert_match "brew,Homebrew Formulae,✓,✓",
      shell_output("#{bin}/mpm --table-format csv --all-managers managers")
    # Check mpm is reporting itself as installed via brew in a table row.
    assert_match "meta-package-manager,,brew,#{version}", shell_output("#{bin}/mpm --table-format csv installed")
  end
end
