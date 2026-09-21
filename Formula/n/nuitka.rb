class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/c7/ce/38409fc853cc26d86ab71ccd53f7dfddbc7a84d4821b9b54db428b35779b/nuitka-4.2.1.tar.gz"
  sha256 "815c6e571a7a6424af384fe9d95d4ba38f1634d39a5515e8094d7fbfa090cbcb"
  license "AGPL-3.0-only"
  head "https://github.com/Nuitka/Nuitka.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc2d760fa0f7b9f4397f1cccb0a1c10e996a09cdc88be3968bdbf1da56d3b4c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93fbcf03989703be1dd9cd9aaccba7df8e74400e60146a4e6853f3508bedfcbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0059fce146eb290a626160c27f2dc82a1a035a633752ae35e766c03c54d2ab9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "abb43d672314778277adace4c772986ca4697ee6aecd09cc2711a5660644a1ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4db9b94045a265b20323bbb765a65f96df13820a8812aa41c1794efb63f34edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ae9bb805d18b48c7a76fe311a97a5f15bc927fb2352afc144c0eb771a0982184"
  end

  depends_on "ccache"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf"
  end

  def install
    virtualenv_install_with_resources
    man1.install buildpath.glob("doc/*.1")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    PYTHON
    assert_match "Talk Hello World", shell_output("#{libexec}/bin/python test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
