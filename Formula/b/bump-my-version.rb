class BumpMyVersion < Formula
  include Language::Python::Virtualenv

  desc "Version bump your Python project"
  homepage "https://callowayproject.github.io/bump-my-version/"
  url "https://files.pythonhosted.org/packages/a0/fa/3ade689370780989831e574e82024d301ffa5ef75b3d169a7074c9419ce4/bump_my_version-1.2.4.tar.gz"
  sha256 "998abb4f3774cf96137a77034a5a12a722b109b26a3afa044ec14622a0180fa3"
  license "MIT"
  head "https://github.com/callowayproject/bump-my-version.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "96ddafce818198afcc5483f6b39cabc8916f8afd79f1643075ec8bc0599bcf5a"
  end

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/20/c5/dbbc27b814c71676593d1c3f718e6cd7d4f00652cefa24b75f7aa3efb25e/pydantic_settings-2.11.0.tar.gz"
    sha256 "d0e87a1c7d33593beb7194adb8470fc426e95ba02af83a0f23474a04c9a08180"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/f6/45/eafb0bba0f9988f6a2520f9ca2df2c82ddfa8d67c95d6625452e97b204a5/questionary-2.1.1.tar.gz"
    sha256 "3d7e980292bb0107abaa79c68dd3eee3c561b83a0f89ae482860b181c8bd412d"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/bf/d8/f2c1b7e9a645ba40f756d7a5b195fc104729bc6b19061ba3ab385f342931/rich_click-1.9.4.tar.gz"
    sha256 "af73dc68e85f3bebb80ce302a642b9fe3b65f3df0ceb42eb9a27c467c1b678c8"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/79/3e/c0bdc27cf06f4e47680bd5803a07cb3dfd17de84cde92dd217dcb9e05253/wcmatch-10.1.tar.gz"
    sha256 "f11f94208c8c8484a16f4f48638a85d771d9513f4ab3f37595978801cb9465af"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
