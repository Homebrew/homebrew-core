class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/3e/65/4059cf029a8782706f53871bcd5402873923bf04353014bf27bc8d5fb2d7/copier-9.2.0.tar.gz"
  sha256 "4ed9012579923955d3fc61d049568907fabe6d9a47e5f871236c6aae0b7472f1"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "2215eb80bb1e8178fd66bc7b0365dd6ba66567ab146f5bcf89a348eeacfff332"
    sha256 cellar: :any,                 arm64_ventura:  "8ed436b7101b98ca27b41da05e6c9a6ba891d336bad6ea2057468c9c22698f4f"
    sha256 cellar: :any,                 arm64_monterey: "4f1d3489cad8cd26165df16f0b4da8bf4706e0e3f9b5ee70dd05ed5aaf11dc9c"
    sha256 cellar: :any,                 sonoma:         "c6cde04b5ea57149c0d22b7ac19937f38e84eeff8f227f5f3212c96142701760"
    sha256 cellar: :any,                 ventura:        "56d87d11f2a7cc14f9eaba32f7cd61b022893b08daf72ce77b6ec607701f01c0"
    sha256 cellar: :any,                 monterey:       "877176aeba1588233cb5489a1ebce8751cdb05251f7cb4bfcc753e3096d51935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64337e626fddd00ca022b2a96b80b2f23747169058c413b234579f879f9ff31"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/e0/84/e321b67334207eefeda01942cd57c93ed985e2a4b5e1af1cd60458d7d0d0/dunamai-1.21.1.tar.gz"
    sha256 "d7fea28ad2faf20a6ca5ec121e5c68e55eec6b8ada23d9c387e4e7a574cc559f"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "jinja2-ansible-filters" do
    url "https://files.pythonhosted.org/packages/1a/27/fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7/jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/23/62/06260ec9f1f5a8c04418f8c8c7c2877c80cac4ead97224fc14d92f0db6b4/plumbum-1.8.3.tar.gz"
    sha256 "6092c85ab970b7a7a9d5d85c75200bc93be82b33c9bdf640ffa87d2d7c8709f0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/0d/fc/ccd0e8910bc780f1a4e1ab15e97accbb1f214932e796cff3131f9a943967/pydantic-2.7.4.tar.gz"
    sha256 "0c84efd9548d545f63ac0060c1e4d39bb9b14db8b3c0652338aecc07b5adec52"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/02/d0/622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6/pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/84/d0/d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535d/questionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin/"copier", "copy", *params, "--vcs-ref=v0.1.0",
      "https://github.com/copier-org/autopretty.git", "template"
    assert (testpath/"template").directory?
    assert_predicate testpath/"template/.copier-answers.autopretty.yml", :exist?
  end
end
