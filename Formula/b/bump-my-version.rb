class BumpMyVersion < Formula
  include Language::Python::Virtualenv

  desc "Version bump your Python project"
  homepage "https://callowayproject.github.io/bump-my-version/"
  url "https://files.pythonhosted.org/packages/cc/28/a3c548aa0f65db43ccb58e29eae97772f3ab70a5ada306718acb9659f5dc/bump_my_version-1.7.0.tar.gz"
  sha256 "286e5755768a0d78596fa1854f4c16d258ec4b61a0aaa580cffe7f9ecf867f83"
  license "MIT"
  head "https://github.com/callowayproject/bump-my-version.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd8ba62c3fb60c09bd40e8e7c60bcf64d82b03f40273949607110c0cce11267b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d942a5201ac0f6d4e3c61d8a56198d00db38df266b8df378e7b0c28bf0a809d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dac2215bca00ad8946ac278377d0b48448696a8b9ad060d54c22925d3b124b0f"
    sha256 cellar: :any,                 arm64_linux:       "c51c75c6e1810c335c9d50d271756ff91beb09a89a5d4aaa584cdcfb0f9ec20f"
    sha256 cellar: :any,                 x86_64_linux:      "de21874a76b9c51987fe954577e5348d2ec99a7c848c55136e55ee3baa0c2701"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/fb/37/adf8dd2cde958c2d086bdd87fc36b532fd824bf38f10be6348d65da0c8f9/bracex-3.2.tar.gz"
    sha256 "0a3d40bfae4caae4d3bfd0ea715874799fab711c38fd4012cc35343e815405cd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/d0/31/21d21e0e38a8f5f7a7f0cde22820117b6d17d6bc36f348129527f915d7f4/pydantic_settings-2.16.2.tar.gz"
    sha256 "3dc08ffabed2bbd5dc2dd55ead7b78b4e4c5cd776aecd04310db5f1224caaf46"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/96/3e/5688fdd83aea416de336582a274f2bc8236b5c261b04c11e17bc262786ad/rich_click-1.9.9.tar.gz"
    sha256 "324cba7513cd4187ee92b2eef21f071714e45be062458c8b157bd7e0c81103e3"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/bd/07/b7a9162a804bc0f7d03fe84c93e374d3e1c4d828043d5f9b797f7d4e30e0/wcmatch-11.2.tar.gz"
    sha256 "1605bde546fbde4c063628c7d89eda486909fd4337e51d73a873987fbcb2554c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"bump-my-version", shell_parameter_format: :click)
  end

  test do
    ENV["COLUMNS"] = "80"
    assert_equal "bump-my-version, version #{version}", shell_output("#{bin}/bump-my-version --version").chomp

    (version_file = testpath/"VERSION").write "0.0.0"
    system bin/"bump-my-version", "bump", "--current-version", "0.0.0", "minor", version_file
    assert_match "0.1.0", version_file.read

    system bin/"bump-my-version", "bump", "--current-version", "0.1.0", "patch", version_file
    assert_match "0.1.1", version_file.read

    system bin/"bump-my-version", "bump", "--current-version", "0.1.1", "major", version_file
    assert_match "1.0.0", version_file.read
  end
end
