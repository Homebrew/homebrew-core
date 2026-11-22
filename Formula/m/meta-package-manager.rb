class MetaPackageManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Wrapper around all package managers with a unifying CLI"
  homepage "https://kdeldycke.github.io/meta-package-manager/"
  url "https://files.pythonhosted.org/packages/ea/d2/abd332eb590b8d028f063ade8f4f1dabb8dc4834c38f0957a693ca1ee3f8/meta_package_manager-8.3.1.tar.gz"
  sha256 "004b110788cc611666dd285c2a61b5bcdddb748222358adca3e8761df0f3be30"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/meta-package-manager.git", branch: "main"

  bottle do
    manifest_sha256 "409a00af8c09059f212ec3dedbb3ac77d0d44c936c02dec6fef0deabeb0e6b3b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fae1b4b20e8a6ca050c64525581a9fffa37021169f8409eadb86df67244ae2f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "506d15294a10a37f617769d694f34bfd9a740f1f538c645dcef511ad9745076e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63f13b304a667680d33861daf9f10776d23a60bb9415ab0ca39a1a9b0288d98d"
    sha256 cellar: :any,                 arm64_linux:       "e6de853f890fcb673df90ac6d0f13bb8d9c1b42c28d166f3c2639d10943e3616"
    sha256 cellar: :any,                 x86_64_linux:      "d7e24e85d7ee2fe6750ee043fb6dda20fca62332a9eb2cfae6b6013e72861bc1"
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
    url "https://files.pythonhosted.org/packages/66/6f/95a6fcb1c430007cda4122c77aace4541fba297f08e2be791ab235a4c548/bracex-3.2.4.tar.gz"
    sha256 "c1e67eb59f81445dee15b2c588b7c81352b697cfbd6c4931a2943ea6b71eb5ea"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/18/50/a7ecb15b045cbad2fb4ab5f23bce1f16d6305bd687ca62eef8abeedd1dd4/click_extra-10.3.1.tar.gz"
    sha256 "1289c8e1eb7cf871a7eab64bb8cf91374e9ad99ffec5cd61619a890ce1f0adef"
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
    url "https://files.pythonhosted.org/packages/96/3a/fd5e95b2c1c04e3874682f9796d06f7389e2a95ab581177800ca17e785fa/wcmatch-12.0.4.tar.gz"
    sha256 "23fe77fbfa3fff9e46f0f4a3d1891065270596774bd6131bd2f973fb822242a1"
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
