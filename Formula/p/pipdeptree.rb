class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/06/68/8b0bca63d885a34bc7f8bcbc001bb9ffdc937fdada1d01d09f9af7785250/pipdeptree-4.1.0.tar.gz"
  sha256 "6eb7e671ffa06ef597d683680d483a4882a86a2a00494971733bd88a3404c44f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dac05abc8d96db8db287eccab40b163d556be51f9d7a551f05573f6892984fa9"
    sha256 cellar: :any, arm64_sequoia: "be8eb7a4309bba470426652afd5475a4477565aa14ceb47a9b2670bf60227fa5"
    sha256 cellar: :any, arm64_sonoma:  "9fc8bad90d6d9d8c94d5aca460827019dff61493ba4df85561fce2886faf33d0"
    sha256 cellar: :any, sonoma:        "bbf7a556f710d3f2bfa551e253c845739a400d7d85f7368c576b16781914fe44"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  resource "build" do
    url "https://files.pythonhosted.org/packages/78/e0/df5e171f685f82f37b12e1f208064e24244911079d7b767447d1af7e0d70/build-1.5.0.tar.gz"
    sha256 "302c22c3ba2a0fd5f3911918651341ebb3896176cbdec15bd421f80b1afc7647"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/06/fe/b9f481cf0cc867958a21338baa900357b7b7d86cac9b025948049d77923c/installer-1.0.1.tar.gz"
    sha256 "052c7fc3721d54c696e2dea019be67539d7b144e924f559f54beb3121831c364"
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
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
