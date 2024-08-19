class Chkbit < Formula
  include Language::Python::Virtualenv

  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit-py"
  url "https://files.pythonhosted.org/packages/ce/c3/83700e8a9c188638403e5eb897c59e8940af0fac3a37678c22b996c8c9f8/chkbit-4.2.1.tar.gz"
  sha256 "6dbcb17c43667fcd63189e0c4682c83bcf0a6d0663e043fe08e4cda565cb1c3e"
  license "MIT"
  head "https://github.com/laktak/chkbit-py.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eca43da47371875365f790d768a4c659af462c1aa0b12fb5ad462dd45a20e38a"
    sha256 cellar: :any,                 arm64_ventura:  "6266986c2a346550d5112318e3d3d174a531943e87640923f7a86286ad310dc8"
    sha256 cellar: :any,                 arm64_monterey: "ea5749e4aa1f96805a69a0f0b0ceef26c49ba5894fce7aff8af1665997b85720"
    sha256 cellar: :any,                 sonoma:         "9fbcdc42034ae0d906ca14794a07f0c2e37278046c5fdcfcc349043340a6e550"
    sha256 cellar: :any,                 ventura:        "81ce5dc4ffcc1812df1101ab0c697c7eb60548ae9d4e42844267edabd2af25cc"
    sha256 cellar: :any,                 monterey:       "73327c0a66310ba120b57391fc5e93601dea45fcd601712d0c3f2ca1f9f77e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5eb0a6a4d5101e55ce44c31bb6369b34c937723e844befd18c6271459d4f00"
  end

  depends_on "rust" => :build
  depends_on "python@3.12"

  uses_from_macos "zlib"

  resource "blake3" do
    url "https://files.pythonhosted.org/packages/b0/8d/43eafa8a785547c33b611068ffd6d914f5c5f96637d5b453abc556f095a0/blake3-0.4.1.tar.gz"
    sha256 "0625c8679203d5a1d30f859696a3fd75b2f50587984690adab839ef112f4c043"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/chkbit --version").chomp

    (testpath/"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin/"chkbit", "-u", testpath
    assert_predicate testpath/".chkbit", :exist?
  end
end
