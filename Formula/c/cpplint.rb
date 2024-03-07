class Cpplint < Formula
  include Language::Python::Virtualenv

  desc "Static code checker for C++"
  homepage "https://pypi.org/project/cpplint/"
  url "https://files.pythonhosted.org/packages/18/72/ea0f4035bcf35d8f8df053657d7f3370d56ff4d4e6617021b6544b9958d4/cpplint-1.6.1.tar.gz"
  sha256 "d430ce8f67afc1839340e60daa89e90de08b874bc27149833077bba726dfc13a"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb957a97eaad0daeb98d695b945e8aea09267cf91421ff1fc5c13df7ff65363f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fd37f88b0709432fde61363cf1f122af4b62cc6b9f61e903ad3efeb2ee75b75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a421073e0f1a6913f84a606bb6d0f2255939d551ff72b0d88fa342719478a25"
    sha256 cellar: :any_skip_relocation, sonoma:         "1199dfcd041ae8d60e1a40c2f5af0aef7220d299e8393a7347daf7e8b25abc2e"
    sha256 cellar: :any_skip_relocation, ventura:        "51ff0b8faa6a9a54bcc265aaf307fbcb8bb759381723161745536e1b1033572b"
    sha256 cellar: :any_skip_relocation, monterey:       "19b3b02254b54bb04fcbe8defa2b3d0954d5ca4b17c3999fa168d15460df71ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfe77e381361892a458fa4851680be39db2a287bb5954ca9cab86d9d781ebc8d"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  def install
    virtualenv_install_with_resources

    # install test data
    pkgshare.install "samples"
  end

  test do
    output = shell_output("#{bin}/cpplint --version")
    assert_match "cpplint #{version}", output.strip

    test_file = pkgshare/"samples/v8-sample/src/interface-descriptors.h"
    output = shell_output("#{bin}/cpplint #{test_file} 2>&1", 1)
    assert_match "Total errors found: 2", output
  end
end
