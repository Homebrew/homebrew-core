class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https://pdm-project.org"
  url "https://files.pythonhosted.org/packages/c1/a0/8771df689a3bc27932641dfba6597309a917c07d5dbd8bbd3203d240017e/pdm-2.29.7.tar.gz"
  sha256 "cc58224755ef310d2c7f0f0276782b0068da9a7d5bc70da995c1bf55c1a8296a"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04c845211ee1df4d0ca2b3e436215f2a13861318a4aa28b27d9283dabcf47b1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3854b663965e2a154fdca17d1c7be8cd5329d8152e924094f3b72e67a2366ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2fadf7e0d1dad58c6071c967e91920d988f8d3f6e3d7efa87cae84f505cbddf"
    sha256 cellar: :any,                 arm64_linux:       "ba835681c01f7f837bcd4cfc74b53e4d86885344314c40c8c41be6c922276257"
    sha256 cellar: :any,                 x86_64_linux:      "1b7f6a6283c27be466fae01453ea2d7ae8293d3d00391e466b1ed0af00789c66"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "anysqlite" do
    url "https://files.pythonhosted.org/packages/0f/4b/cd5d66b9f87e773bc71344a368b9472987e33514e6627e28342b9c3e7c43/anysqlite-0.0.5.tar.gz"
    sha256 "9dfcf87baf6b93426ad1d9118088c41dbf24ef01b445eea4a5d486bac2755cce"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "dep-logic" do
    url "https://files.pythonhosted.org/packages/1b/7a/ac7db322bfc792c237e059e0b048e8e0784eb624d0447e3cf5e231323725/dep_logic-0.7.2.tar.gz"
    sha256 "2a3c49526075b0bc6825f0ea8c2d9f464de48b7b85f3f3d2900b4e5950fefedf"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a3/1d/d730c664fcb4f1d264a722722a3134cf0881854f73c1fd58abf87572f232/filelock-4.2.9.tar.gz"
    sha256 "96530b7c538d4ea08493ab067247aab7948c54d8cd622cce711c97cccc5d9896"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/db/81/bbf87eebd5d9a98982f0bc4b8a8ba46fe2e607cfc2fda6d33ea2d8d3289c/findpython-0.9.0.tar.gz"
    sha256 "497c6b5eb13734be2542dfb6a93267946339601cbc2f1138c8cd4d40311fefe5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hishel" do
    url "https://files.pythonhosted.org/packages/13/83/e8c4e482b6f5e9c2f9d1c7a1503137eed81b689d358ae0df6ac50d79f172/hishel-2.0.0.tar.gz"
    sha256 "f043c88acf9b476fdbf203986253cd4e27e2468a3319b43c3946a641e1cb7696"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "id" do
    url "https://files.pythonhosted.org/packages/6d/04/c2156091427636080787aac190019dc64096e56a23b7364d3c1764ee3a06/id-1.6.1.tar.gz"
    sha256 "d0732d624fb46fd4e7bc4e5152f00214450953b9e772c182c1c22964def1a069"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/56/d3/2fab33d15004d41ae8e7b5d3e310510f7f34a7e1dd032a3e60d8b38d8fba/installer-1.1.0.tar.gz"
    sha256 "5adc0c01ce62d809989e246987cd68944fe5df8af562d0358f65b2ab15cb5de7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cc/52/1ec7ead2c7528bf3d1db73e886fa4df10f9e6f0eb7854a448b7090cfcef7/msgpack-1.2.4.tar.gz"
    sha256 "475c44e12f2a5de766a8448783f149c9b33f3f49b88953c6cd739a77d93c732c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pbs-installer" do
    url "https://files.pythonhosted.org/packages/f6/26/a2c87997a30cb6484822c24e8d9e7d43ece8705f71735644da9f588be8d8/pbs_installer-2026.10.25.tar.gz"
    sha256 "d7cfcc37f15f55926d51b93e5275cca548e2d91fe530109f56258bc3aa754ea9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/6d/5d/f2ddeef4a855a102aaae5e97826a0260007522ab504421b75addfdb1517c/pyproject_hooks-1.3.3.tar.gz"
    sha256 "defda19b854fa0d3bd4f76ea4ddcba8abd7dcfcdd585a6690ade050744fc5f43"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0f/d7/1e94df7d1636bf00b9f261bf88a4adc0414f14931ff60511eb0f34c250d1/python_discovery-1.9.4.tar.gz"
    sha256 "c01b45fe515c1d268b57c57d554bb0e1d320b8e9eb5490bb2f4f577be26e4380"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/1d/14/4669927e06631070edb968c78fdb6ce8992e27c9ab2cde4b3993e22ac7af/resolvelib-1.2.1.tar.gz"
    sha256 "7d08a2022f6e16ce405d60b68c390f054efcfd0477d4b9bd019cc941c28fad1c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "socksio" do
    url "https://files.pythonhosted.org/packages/f8/5c/48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85/socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"

    # Unpin flit-core<3 to support 3.14+
    patch do
      url "https://github.com/sethmlarson/socksio/commit/b326406915fd98a8185c1c160165c5b8963b30c1.patch?full_index=1"
      sha256 "7aefa906b62e2c9a8df255ea742ca97e155ac2e1238e49ce11e3e56e37ee1f8b"
      type :backport
      resolves "https://github.com/sethmlarson/socksio/pull/61"
    end

    # Fix for flit-core>=5
    patch do
      url "https://github.com/sethmlarson/socksio/commit/504f7e51682b9526d3ecc7ea893338af1fedfb2d.patch?full_index=1"
      sha256 "b0c327c4e8fa722669dc372263d735f429015587e02935e2e8cb2b22028c0bfb"
      type :backport
      resolves "https://github.com/sethmlarson/socksio/pull/66"
    end
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "unearth" do
    url "https://files.pythonhosted.org/packages/37/84/fb5929b8ce02c57b266abf4fbba6fb561649b024e3268a3625820de872dd/unearth-0.19.0.tar.gz"
    sha256 "d85a7b164833c1dc8532a590043cbd7159f6ad2b91fc3e74f2a16ff25ed098c8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/69/74/745e612b69ad14a534b7bc233c4574b968eb2c21a276ea172e8f0fc13f51/virtualenv-21.15.5.tar.gz"
    sha256 "fb869ea32930530ccc87549877b53268c2a4d4a7d7f2c384042eca05170350e6"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"pdm", "completion")
  end

  test do
    (testpath/"pyproject.toml").write <<~TOML
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-backend"]
      build-backend = "pdm.backend"
    TOML
    system bin/"pdm", "add", "requests==2.31.0"
    assert_match "dependencies = [\"requests==2.31.0\"]", (testpath/"pyproject.toml").read
    assert_path_exists testpath/"pdm.lock"
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.31.0", output.strip
  end
end
