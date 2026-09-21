class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/78/39/632ef8751bc0415c198b7a27aef7cc4fbef619a0b502fd491d70695d5587/pipdeptree-4.2.5.tar.gz"
  sha256 "0fafc3201c046e72913abb8a7a2b75cb17c3e15ebdd3ed546adf8fe9a9d4f54e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a4dad65f973b6a436b82a0d8fcd24e90644648b68ff7c86d840219484d2f0498"
    sha256 cellar: :any, arm64_tahoe:       "7ec645ea680a132d8f3647f8778224b592fb2925554f6558032c32599ee715a3"
    sha256 cellar: :any, arm64_sequoia:     "be5100bac3fe3dcc7164e116865cd112ad717001833744321ed5f684468be3f2"
    sha256 cellar: :any, arm64_sonoma:      "22c219d8d61013de345ad62ec74ae98b51d41d51b31fb072792d7002066d9477"
    sha256 cellar: :any, arm64_linux:       "dca8aca79424de9e71842578ec5e39021218a304a44df79d3503039a9bb87adf"
    sha256 cellar: :any, x86_64_linux:      "b0f880e27bbcb1b41aca30ca5a4139c67a276350c04f583061d2b849663db394"
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
    url "https://files.pythonhosted.org/packages/52/08/c57125a1d29b719aa4268df29fa41bb3d384d7751046624480bd8a094489/meson_python-0.21.0.tar.gz"
    sha256 "595c2f40b76692c78274c87b733379d86562583e9ffb975487b9eafada03055b"
  end

  resource "nab" do
    url "https://files.pythonhosted.org/packages/c2/8a/32bfa9daa9ba35e27b92c3d2196a0243d44437bd2b080bc929573843c9c3/nab-0.0.17.tar.gz"
    sha256 "ac6adb24630140e32ad872413284199381f0b9d1ed758e3d98bda6cd42a160e2"
  end

  resource "nab-index" do
    url "https://files.pythonhosted.org/packages/86/fc/886ecd2b68d2aa51273443c0b6cd4bf1872da57965a105809451515db825/nab_index-0.0.17.tar.gz"
    sha256 "42fc55638c1f6a075707cd6aaa2fa4e7b04b093e24f29e0eb554db5beb0a7dc9"
  end

  resource "nab-markersets" do
    url "https://files.pythonhosted.org/packages/ec/6a/c4f7b21c80a2b5d7e740431f044755d3253648795f63ada3678c91c4f651/nab_markersets-0.0.17.tar.gz"
    sha256 "ece0e926d39d1f77a39652cd87da95e425e2f02acbac20e692e8b3e593903f46"
  end

  resource "nab-project" do
    url "https://files.pythonhosted.org/packages/32/2b/6e491bb35b0833ff817cb802f828ca1f4273cc93724cf9aa96aabb6df7cd/nab_project-0.0.17.tar.gz"
    sha256 "392a8bf8d7a708ddb47e8e7d3143ac9d53188be573bd69fbc2470b27eb7e7cb3"
  end

  resource "nab-provider" do
    url "https://files.pythonhosted.org/packages/da/47/e1c56ba2b1d53ede590c4df823d607aa52154ced2daabb16a281918c0e77/nab_provider-0.0.17.tar.gz"
    sha256 "117b62614836240b68b5844673047252c6181b685aa09e7e7b612b83cc6decc9"
  end

  resource "nab-resolver" do
    url "https://files.pythonhosted.org/packages/ad/07/9dc098e3a1f0332413b46c95158edbd09c7a73ccab8a225aab9e01644d3a/nab_resolver-0.0.17.tar.gz"
    sha256 "523914553615f5c7427cf0fdf5bf95f3152d73affa0cbb57d40fb0a5983bcc5b"
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
