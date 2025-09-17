class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://files.pythonhosted.org/packages/24/11/005da9e0826ff333096763597699f5ac9ede8e57e31d94d52300e4bc8f1f/Nuitka-2.7.14.tar.gz"
  sha256 "88233ed175d6d2abb2e1d5fa3c2e28b2fac604764ddc319c614325ff87c77117"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a74cb8e127839acdad3211bd1cecf4c2e122e46441c5c8536e1a0cca5672a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4569e10bf571c9cc4c0364d29b3d4e4fcdf193ab7d82a5e4a5649b53749bdfe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60cd7e39fbcf8504f8be4134969b36e5c02b78a326df2a490098e0011db9329"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55eff93a7a9eb385341432c06567731606a2753ef4e6bd7ca7d53f722ae95a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "4efcbe16c0dde9784585545c3310df3127db4f65a969e6e80a056d60437f797f"
    sha256 cellar: :any_skip_relocation, ventura:       "6f9fce8b792ec1758e4c21d4017f148680c06e4ba7ab21644d8989b2fd36fb6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7dc252e98451a5a20b358de35e9f0a591074cd96d33bf645dd51e0161412407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "863d93ab4574dbce8fde9707fd220338f25bdcdeb30f3e99447fc93d6b4fc38d"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf"
  end

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/09/1b/c20b2ef1d987627765dcd5bf1dadb8ef6564f00a87972635099bb76b7a05/zstandard-0.24.0.tar.gz"
    sha256 "fe3198b81c00032326342d973e526803f183f97aa9e9a98e3f897ebafe21178f"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
  end
end
