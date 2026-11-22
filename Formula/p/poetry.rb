class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https://python-poetry.org/"
  url "https://files.pythonhosted.org/packages/9b/42/8da80ea396ffc83f2d1d3f05ce71e5eb79847c15314267aba59c0391054b/poetry-2.5.2.tar.gz"
  sha256 "131d6a565f809436918a5aafed34e7013038fc73b4f7b64640dc278f14adc4ea"
  license "MIT"
  head "https://github.com/python-poetry/poetry.git", branch: "main"

  bottle do
    manifest_sha256 "e64a0e8093f2112e01ce56f381beb9bebcb28d78d5c857243763b80d23154c71"
    sha256 cellar: :any, arm64_golden_gate: "c07d61d7364aa84a50e03412a4a4c5f9640573af7aab8aa4aaf9f75ec2e07b1d"
    sha256 cellar: :any, arm64_tahoe:       "2506bb63b715626aa15a893da6c193dc7bbcf5f8f08067646fd54eda9ec538f3"
    sha256 cellar: :any, arm64_sequoia:     "fccda292c9c44e7c845274fe6bc910c6bd7dcfafa5a60b6f4ece1ec621e46294"
    sha256 cellar: :any, arm64_linux:       "03f9b5ce565723cdfbc4b73af5db7396ad4e9fb94d1fa1eef18fef69836759df"
    sha256 cellar: :any, x86_64_linux:      "91fd760dbde7c737312d043b45123940b04915935e884174e2c980f9cd97553a"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "ninja" => :build # for rapidfuzz
  depends_on "rust" => :build # for cachecontrol
  depends_on "certifi" => :no_linkage
  depends_on "cffi"
  depends_on "python@3.15"

  uses_from_macos "libffi"

  on_linux do
    depends_on "cryptography" => :no_linkage
  end

  pypi_packages exclude_packages: %w[certifi cryptography],
                extra_packages:   %w[jeepney secretstorage xattr]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "build" do
    url "https://files.pythonhosted.org/packages/bd/67/4898a44ea4f3f8e213b0954ec0aa0a16971d62a6212d6ea3931e97115b99/build-1.6.1.tar.gz"
    sha256 "51cc11666391ab6f092070437ac747002ff46f3e4113a3622177ee6b488bfc53"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/2d/f6/c972b32d80760fb79d6b9eeb0b3010a46b89c0b23cf6329417ff7886cd22/cachecontrol-0.14.4.tar.gz"
    sha256 "e6220afafa4c22a47dd0badb319f84475d79108100d04e26e8542ef7d3ab05a1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cleo" do
    url "https://files.pythonhosted.org/packages/3c/30/f7960ed7041b158301c46774f87620352d50a9028d111b4211187af13783/cleo-2.1.0.tar.gz"
    sha256 "0b2c880b5d13660a7ea651001fb4acb527696c01f15c9ee650f377aa543fd523"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/6e/5d/d79f51058e75948d6c9e7a3d679080a47be61c84d3cc8f71ee31255eb22b/crashtest-0.4.1.tar.gz"
    sha256 "80d7b1f316ebfbd429f648076d6275c877ba30ba48979de4191714a75266f0ce"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/01/d1/01adf1db003374db4c2a70f7bae757ddfc39a33d9fb5ab765522b4d339e6/dulwich-1.2.21.tar.gz"
    sha256 "5d3939f64883e6799614cab708ef4ee9ef415dd6dcad47527cdbb0eea43bf3a2"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/1c/80/cc3c531dd70c8ffa1045aecf33c97c5581cc8fd0e824b3ecb2c1881550c1/fastjsonschema-2.22.3.tar.gz"
    sha256 "8330c91b027dcf941efcb7b1f0998515ff95d177ea15bbabdfe8671965620901"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/52/aa/8ccff8da9a27e089727fcffd3c5b61708383217e47eb1e1b8af37b1dd166/filelock-4.2.12.tar.gz"
    sha256 "7e7da24d3ac39268b0f156e56870001de44886318f092f9d851e692f7114d6dd"
  end

  resource "findpython" do
    url "https://files.pythonhosted.org/packages/78/e5/dd65baa266c24fa2ff9aaed20e17ec6530c063939fd11741964085a02d76/findpython-0.8.0.tar.gz"
    sha256 "53b32264874dfa5990bd09d717819386d8db3149d89fe20f88fe1078de286bae"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/92/9d/df40b41f7db0370f82019820709244e7b660c52aa3da3c9e5c4e8141f6e6/httpcore2-2.16.2.tar.gz"
    sha256 "6c519d0f7b44f7269fa9bbb4d2763db395a4a2370f046d8e8e0a4b38227815d2"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/1c/77/6515121dc5ac3c743ad1bff5afe635bcd1a3f23cc40db3c5c89f7d02917d/httpx2-2.16.2.tar.gz"
    sha256 "748b615678f07d8e3b183efe81ad13b655ca88bfc56ce4589219b2d442860574"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/56/d3/2fab33d15004d41ae8e7b5d3e310510f7f34a7e1dd032a3e60d8b38d8fba/installer-1.1.0.tar.gz"
    sha256 "5adc0c01ce62d809989e246987cd68944fe5df8af562d0358f65b2ab15cb5de7"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
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

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/30/37/7580f0accc77d450a53ff7856fe142a89fc11467c2f22105dd06e088a5d1/pkginfo-2.0.tar.gz"
    sha256 "f7b4f267881785582c923631a0fa7e275b0d390a5cbab54aa4ec0ecc7eddb375"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/6d/5d/f2ddeef4a855a102aaae5e97826a0260007522ab504421b75addfdb1517c/pyproject_hooks-1.3.3.tar.gz"
    sha256 "defda19b854fa0d3bd4f76ea4ddcba8abd7dcfcdd585a6690ade050744fc5f43"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/cb/4e/20a9c45c4bb839e6e03e5971a546c623d12f950aa496cf344dc8e9f07167/python_discovery-1.9.6.tar.gz"
    sha256 "383aa67858d73a9585a843a37a4383c6be98e4d86a981a031328e393a6eb2632"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/18/97/226c43b7b5d957bc3840ed52ea99eed261f99834c4619be7a4742cbaeafa/rapidfuzz-3.14.6.tar.gz"
    sha256 "e13a8160d017b499ec7a2fa9d0ce1ae2e7377080815785819f966fb235d4eb60"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b7/db/4281879de138c880ac9f4c697f633e05f2703912f0fd0add006474db7f27/virtualenv-21.15.11.tar.gz"
    sha256 "6ad11e129f546835ae81d47a27f48ed32dcc4e2a0776014a159bab8895cdb9ac"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/7d/52/0f200beac11d7b6bb6fca01601154369420bcac5551f903894cbc17c8b3e/xattr-1.3.1.tar.gz"
    sha256 "55003624ea1d4a0e769d803892dd66697fb485f1aab7269dfcfab68ea5bd72f4"
  end

  def install
    without = OS.mac? ? ["jeepney", "secretstorage"] : ["xattr"]
    virtualenv_install_with_resources(without:)
    generate_completions_from_executable(bin/"poetry", "completions")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    # The poetry add command would fail in CI when keyring is enabled
    # https://github.com/Homebrew/homebrew-core/pull/109777#issuecomment-1248353918
    ENV["PYTHON_KEYRING_BACKEND"] = "keyring.backends.null.Keyring"

    assert_match version.to_s, shell_output("#{bin}/poetry --version")
    assert_match "Created package", shell_output("#{bin}/poetry new homebrew")

    cd testpath/"homebrew" do
      system bin/"poetry", "config", "virtualenvs.in-project", "true"
      system bin/"poetry", "add", "requests"
      system bin/"poetry", "add", "boto3"
    end

    assert_path_exists testpath/"homebrew/pyproject.toml"
    assert_path_exists testpath/"homebrew/poetry.lock"
    assert_match "requests", (testpath/"homebrew/pyproject.toml").read
    assert_match "boto3", (testpath/"homebrew/pyproject.toml").read
  end
end
