class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/32/fa/04921cc3e3721889462371130af1c0ed8a53aa2babe5570180d7e0592036/pdm-2.19.0.tar.gz"
  sha256 "4dda3caec3a5e4d9942c9bc6f3bdcf34c60c21e76050ef35f6c27786f4b1d470"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0922f4e0c899aebe48c27accaf42ea48cf48dd027970d0809e42c171473b5b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37390603ad0b17d3d7a518dbffb566bebcd576dc93ecafd34afdc794d9ab4914"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f6180d98b5d3afb5837b72aaafecbafa825b137547f07bdd5af6a927000f0b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "687acccb55101921fc8b09927610b0192969d1193a2e2b4227641c57454ed351"
    sha256 cellar: :any_skip_relocation, ventura:       "5f45f5cff158039b0a2672094f647b2d9a7fed7bf9d072f58697789d70a080cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cece16206ae7abf5e2a93f0fd46c214f90c79d2fedd510c4e64051f0c6db0d94"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/78/49/f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8/anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1e/57/a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abcc/blinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "dep-logic" do
    url "https://files.pythonhosted.org/packages/46/c6/810b34258a5f4be719a74f011e4b6a3bf4fd1fe38a400fe2682f3d87576f/dep_logic-0.4.9.tar.gz"
    sha256 "5d455ea2a3da4fea2be6186d886905c57eeeebe3ea7fa967f599cb8e0f01d5c9"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/29/57/a35de26696baa005ddcfce8af495fb8cdb75942ebebf1cf219a04706fc81/findpython-0.6.1.tar.gz"
    sha256 "56e52b409a92bcbd495cf981c85acf137f3b3e51cc769b46eba219bb1ab7533c"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "hishel" do
    url "https://files.pythonhosted.org/packages/e9/ae/5c9a7841bbc34ca7dbf54fe866c7dad1fe2bc2ba9fc1d40c03794f2eb2ab/hishel-0.0.31.tar.gz"
    sha256 "0577291a0159a466152096e2b8ac33c476707eb6a44e5dca6de5a855d7fbd38b"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/17/b0/5e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926/httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/05/18/ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8/installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pbs-installer" do
    url "https://files.pythonhosted.org/packages/0f/0c/de763ddfe6cd29cc8e48a7df9062ed387dec8dfec6bcdd6ef707f0370f38/pbs_installer-2024.9.9.tar.gz"
    sha256 "bed162d05ef71c53a0e5e5c6349bab1b07a3d0e5af1800d619a4414a1fda309a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/c7/07/6f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6/pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ce/10/f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6/resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/92/76/40f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535/rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "socksio" do
    url "https://files.pythonhosted.org/packages/f8/5c/48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85/socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/df/2e/0e21d4c77bc41c588d3d3c87b8f9b32b2338452718cb261d31cbe55eb4d5/truststore-0.9.2.tar.gz"
    sha256 "a1dee0d0575ff22d2875476343783a5d64575419974e228f3248772613c3d993"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "unearth" do
    url "https://files.pythonhosted.org/packages/de/1f/5664f19db1352460e42f32e39976d8498a0fe056f0495221f53a43599154/unearth-0.17.2.tar.gz"
    sha256 "0b8a2afd3476f1ab6155fc579501ac47fffe43547d88a70e5a5b76a7fe6caa2c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/bf/4c/66ce54c8736ff164e85117ca36b02a1e14c042a6963f85eeda82664fda4e/virtualenv-20.26.5.tar.gz"
    sha256 "ce489cac131aa58f4b25e321d6d186171f78e6cb13fafbf32a840cee67733ff4"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"pdm", "completion")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-backend"]
      build-backend = "pdm.backend"
    EOS
    system bin/"pdm", "add", "requests==2.31.0"
    assert_match "dependencies = [\n    \"requests==2.31.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.31.0", output.strip
  end
end
