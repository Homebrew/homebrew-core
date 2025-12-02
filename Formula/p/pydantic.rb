class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://github.com/pydantic/pydantic"
  url "https://files.pythonhosted.org/packages/69/44/36f1a6e523abc58ae5f928898e4aca2e0ea509b5aa6f6f392a5d882be928/pydantic-2.12.5.tar.gz"
  sha256 "4d351024c75c0f085a9febbb665ce8c0c6ec5d30e903bdb6394b7ede26aebb49"
  license "MIT"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f82763979e85555515c17cace1a3e82142da86aafbe470a913cff495da4082e5"
    sha256 cellar: :any,                 arm64_sequoia: "1df91d297946b63d060e975586f5704049ff91cee099d6074536ab6d8b913400"
    sha256 cellar: :any,                 arm64_sonoma:  "932a64cd7677c6e78af8d23436fd5c6445971132e36990d9f17da237f836301e"
    sha256 cellar: :any,                 sonoma:        "6ca77c977ee829d61282d6fd0d894e9a23d0ff3654d4825f92e6ab672fc34e39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b252c084afdb03e9871ca69e7969ad5a5120e49ac916414d5ebd0fc63f02c54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ec6ef0299e0e75a011da81902dc8e1da5b3798d010d56e51710537ecd248a8"
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
