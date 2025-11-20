class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://github.com/pydantic/pydantic"
  url "https://files.pythonhosted.org/packages/96/ad/a17bc283d7d81837c061c49e3eaa27a45991759a1b7eae1031921c6bd924/pydantic-2.12.4.tar.gz"
  sha256 "0f8cb9555000a4b5b617f66bfd2566264c4984b27589d3b845685983e8ea85ac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "072d1fb04d90cb1c85737e299f5dfa81a17b4753e1c5ec4c8757400218a5a56b"
    sha256 cellar: :any,                 arm64_sequoia: "1e6b7462653aff4092b3dbaa986d8341e0372ec5a0000d755deb5ba0ce14f6a4"
    sha256 cellar: :any,                 arm64_sonoma:  "a81ed5785760069cf140b134af256535aaeac6b85968b25e2efea30c6128bb18"
    sha256 cellar: :any,                 sonoma:        "12157cdfacdefb620f44603884f82f20611e1692912eff93a700e7e7fd1e0681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a9ba62930ba831f126a5d9e2995131e9b8013cb4227d1384df52ee80a6b843b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff0b840cf632666cfbe22f7f45f8ea1ac2939e972748f5296af3a88018fa24b"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/71/70/23b021c950c2addd24ec408e9ab05d59b035b39d97cdc1130e1bce647bb6/pydantic_core-2.41.5.tar.gz"
    sha256 "08daa51ea16ad373ffd5e7606252cc32f07bc72b28284b6bc9c6df804816476e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  def install
    pythons.each do |python3|
      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    pythons.each do |python3|
      system python3, "-c", "import pydantic;"
    end
  end
end
