class EulerPy < Formula
  include Language::Python::Virtualenv

  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://github.com/iKevinY/EulerPy/archive/v1.4.0.tar.gz"
  sha256 "0d2f633bc3985c8acfd62bc76ff3f19d0bfb2274f7873ec7e40c2caef315e46d"
  license "MIT"
  revision 2
  head "https://github.com/iKevinY/EulerPy.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03e91b3a2d807680b8b6ea95a4c0bfb0e4a2a2216c11d6bb8634e63dfaeb3122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72ce6df1e039ba85021f4dda879163bfcfa58c2f1e56f7b53aae229536eb308a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b20ae7a1e2689ba118d631709173d902d2c9d54bdb9e378ff3680e18f7e48ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "5829b4ea6f41c0105fa3f72d1cb9723b39e6d4bd4d8fc08aad28fb78960a4ca2"
    sha256 cellar: :any_skip_relocation, ventura:        "d0c60d886dbaa9d5c38ba0b29118120c2b4e08e596178d727c2b2bfe4b83deb6"
    sha256 cellar: :any_skip_relocation, monterey:       "47a6c6476ba8ac0777cb35fca74f51521a2f6668a6ab7ff057b15c99b344a790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef6eb10c8e5225fda9b692d78202f1be8e5d0a1afc678a4bbc69e566360e34c"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/7b/61/80731d6bbf0dd05fe2fe9bac02cd7c5e3306f5ee19a9e6b9102b5784cf8c/click-4.0.tar.gz"
    sha256 "f49e03611f5f2557788ceeb80710b1c67110f97c5e6740b97edf70245eea2409"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "open3"
    output = Open3.capture2("#{bin}/euler", stdin_data: "\n")
    # output[0] is the stdout text, output[1] is the exit code
    assert_match 'Successfully created "001.py".', output[0]
    assert_equal 0, output[1]
    assert_predicate testpath/"001.py", :exist?
  end
end
