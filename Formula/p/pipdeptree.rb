class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/a1/68/34d47650e9ad35b7f5beb4666c7a0e79fc2589a839116aadc2e4ab16d2bb/pipdeptree-4.2.3.tar.gz"
  sha256 "f95876e4feddadeaffaeb579990bf94bd6035e7dc87569f5cba2ac6669ea3ebe"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61961ebbd0dfb17b50e37bf74e92c734234d73697e5fedcc9a1590eb9d80db38"
    sha256 cellar: :any, arm64_sequoia: "ae2cbc6c4cba63777a7afefe655140c87d857bf63d3eeddeeb4420ba7fa845c8"
    sha256 cellar: :any, arm64_sonoma:  "0d66850023108b5a75eb82b637f589c566aed2dc928dbbabcfec25b38a96e31a"
    sha256 cellar: :any, arm64_linux:   "f3f4ac0b16be941372778c63cda8e1f35354eabf3a5a5396181ce130a1cf74d5"
    sha256 cellar: :any, x86_64_linux:  "99190f8bf66bf80853e825ccb9e907312b8463a1bde314284114a0c6708c4fbd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  pypi_packages exclude_packages: "meson",
                extra_packages:   "meson-python"

  resource "build" do
    url "https://files.pythonhosted.org/packages/4d/b7/1db48a9ce2984842c8c886432ec8a2719613322e868a966ba82a28862f25/build-1.6.0.tar.gz"
    sha256 "bd2c8afc603e7a2e0ce70e2ea85f0a6d02043bafbd307f5bada0f98669eca5af"
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
    url "https://files.pythonhosted.org/packages/65/16/0be91ce20a971f6ff655b377d6fa61b390ffdda8cf6dfc471b499c6bcf37/nab_index-0.0.15.tar.gz"
    sha256 "0588f2ecde4b2dcf0681ce87dcff7e9e2b46ebedb613ce317bb65a94eb9801ec"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/e9/4b/0cb5c2a434ee19948304baae1d801b9e4f2b6c1622b27861096c79104a90/nab_project-0.0.15.tar.gz"
    sha256 "622b0a04d4ab666ad17e4082ef6250adce2feda3c03f2abe948e0d9fecd56cff"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/7e/fa/302ec23421ad11ca6b6338886c81b241b727900659b87f0f86c9343478f3/nab_provider-0.0.15.tar.gz"
    sha256 "de119ece8691bfc764263a34f1f07283aa1f0f3b54185f5700f97e490dfce312"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/b2/8a/8eb66a839991598a892a3c833903bab97ad85f630a8a58826e98552f88f4/nab_resolver-0.0.15.tar.gz"
    sha256 "5175f2b24ed4b5ed75e5e94186acb9958a580f855589eab47c4a7856114e349c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
    venv = virtualenv_create(libexec, python3)
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
