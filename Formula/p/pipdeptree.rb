class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/c1/95/631bdc59b0f8f0ef8d6b66267fba6a5907278375a255064dbb11dece34ea/pipdeptree-4.0.0.tar.gz"
  sha256 "2012876c6853ad6cccf4537dd5c07d19ac144c7fceb7ab1ef9e234fa6671c3b9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3e9295b3502b0ba7b49c8ec335197d3361c0180e49c0f0d51b13c17c1050a9c7"
    sha256 cellar: :any, arm64_sequoia: "52a51ae55704f1c296e447d47db0e8b8f639e2aeb6a8d0d43708605456661259"
    sha256 cellar: :any, arm64_sonoma:  "c020851117b83113ba98a407245e7d16badc9d3b0a9648b39717e2b4b77fb13c"
    sha256 cellar: :any, sonoma:        "348d2267adf5396322b04523f4a8b30d28aa43b886bb592a813168dac3ae661e"
    sha256 cellar: :any, arm64_linux:   "61d31b89e6c30a6bdf4a0c211ebcd28530d9fcbe7441b8886bcbc054613c5474"
    sha256 cellar: :any, x86_64_linux:  "9d18068422c71a3f6dce8408cdbcc63211c2ceb4a96d900e0bd6baf4ae94c90a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  pypi_packages exclude_packages: "meson",
                extra_packages:   "meson-python"

  resource "build" do
    url "https://files.pythonhosted.org/packages/78/e0/df5e171f685f82f37b12e1f208064e24244911079d7b767447d1af7e0d70/build-1.5.0.tar.gz"
    sha256 "302c22c3ba2a0fd5f3911918651341ebb3896176cbdec15bd421f80b1afc7647"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/06/fe/b9f481cf0cc867958a21338baa900357b7b7d86cac9b025948049d77923c/installer-1.0.1.tar.gz"
    sha256 "052c7fc3721d54c696e2dea019be67539d7b144e924f559f54beb3121831c364"
  end

  resource "meson-python" do
    url "https://files.pythonhosted.org/packages/8b/f0/d794d7ed8a843a8a8947768f3b329d1e8601222dc95d930f4a5f9706cd6c/meson_python-0.20.0.tar.gz"
    sha256 "6d9726ae6cd37e22f210c74b364b30180a68c20442e97ff09f3c566a414af738"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/99/26/df8082b11169a8aa0169f67a00085c978f05d5f1a9f0e9895d13085e0220/nab_index-0.0.11.tar.gz"
    sha256 "cdf3d3868c840896bba56bfc180c5ff5e6f6801ab9697def799208e37b4cf23e"
  end

  resource "nab-python" do
    url "https://files.pythonhosted.org/packages/bf/74/6cc630e82b80e255db1d293b1f053ba25d4985d4d8332ca2efb9fac02f78/nab_python-0.0.11.tar.gz"
    sha256 "c034a432228150afe99c7280d64d4ef738f6182b9079532bc04a2fce94daa2f2"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/25/e4/1c802661870ea6e677b3f48f5751970d5ec4218fe867fe09c9563b13e275/nab_resolver-0.0.11.tar.gz"
    sha256 "9b32dc5b9936964d00c95e5b5e01ce85a9533b2aa95bd4ed96dd793bac61759c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/4f/76/1cae539918a7b1746d624c2f01560b793c22cd8c081157505bb9bbf0e34d/pyproject_metadata-0.12.1.tar.gz"
    sha256 "8809a4df6fe08279b39a8890669506ed3158e0617855ac9aff098fcbe772ae4c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/22/de/48c59722572767841493b26183a0d1cc411d54fd759c5607c4590b6563a6/tomli-2.4.1.tar.gz"
    sha256 "7c7e1a961a0b2f2472c1ac5b69affa0ae1132c39adcb67aba98568702b9cc23f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources.reject { |r| r.name == "meson-python" }
    # meson-python self-hosts via backend-path; without isolation it uses brew meson and ninja
    venv.pip_install resource("meson-python"), build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
