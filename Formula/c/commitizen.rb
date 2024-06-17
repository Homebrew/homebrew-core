class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https://commitizen-tools.github.io/commitizen/"
  url "https://files.pythonhosted.org/packages/f4/31/5efdd1f879da8f86298d24460882d57439e536ddcc4cb2c72cadbc94ff62/commitizen-3.27.0.tar.gz"
  sha256 "5874d0c7e8e1be3b75b1b0a2269cffe3dd5c843b860d84b0bdbb9ea86e3474b8"
  license "MIT"
  head "https://github.com/commitizen-tools/commitizen.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6efaec79ae9c8184b77ba6f1b5fa42b7512d5f47b28f0ecb4e861a52f8edf905"
    sha256 cellar: :any,                 arm64_ventura:  "ad4e381470ae7a6fc04e6a9e60377a5216d8a6b3de64ddb01473448f75d12612"
    sha256 cellar: :any,                 arm64_monterey: "146c1248f318ec11998aa46b8124b7279150ee3a92f56f7fb13ca2af6aa21256"
    sha256 cellar: :any,                 sonoma:         "b8e0467699b39d19d2cd331e4c20e20784ccd646bf67a819185fe3def78bfa72"
    sha256 cellar: :any,                 ventura:        "dc2ecd9f569ef9e08ce4add3a767bc619b2507668d622fed19c632faac750605"
    sha256 cellar: :any,                 monterey:       "863e61f1c1810bbe51cb254df0420202a56fb525557a79bf36edb3a769ae8ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86e4ff985066fb24c508b5e8bc895af51f1162c431989c9de984590196a5820b"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decli" do
    url "https://files.pythonhosted.org/packages/3d/a0/a4658f93ecb589f479037b164dc13c68d108b50bf6594e54c820749f97ac/decli-0.6.2.tar.gz"
    sha256 "36f71eb55fd0093895efb4f416ec32b7f6e00147dda448e3365cf73ceab42d6f"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/84/d0/d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535d/questionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/2b/ab/18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8/tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/16/e5/8efdac4c61bd5fd24f4face2295103f42790ad2ad0f322e3a81bb8391812/zipp-3.18.2.tar.gz"
    sha256 "6278d9ddbcfb1f1089a88fde84481528b07b0e10474e09dcfe53dad4069fa059"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(
      libexec/"bin/register-python-argcomplete", "cz",
      base_name:              "cz",
      shell_parameter_format: :arg
    )
  end

  test do
    # Generates a changelog after an example commit
    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "yes | #{bin}/cz commit"
    system "#{bin}/cz", "changelog"

    # Verifies the checksum of the changelog
    expected_sha = "97da642d3cb254dbfea23a9405fb2b214f7788c8ef0c987bc0cde83cca46f075"
    output = File.read(testpath/"CHANGELOG.md")
    assert_match Digest::SHA256.hexdigest(output), expected_sha
  end
end
