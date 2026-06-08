class Pydantic < Formula
  include Language::Python::Virtualenv

  desc "Data validation using Python type hints"
  homepage "https://github.com/pydantic/pydantic"
  url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
  sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cfb42ea77db358f8b7182a230f3cd9fb5b9612540603ffa0db2d100b29a4a92"
    sha256 cellar: :any,                 arm64_sequoia: "d55b259d1303f4a83a308060283f44acce735cd8700f4b3130daab8e483aa6f5"
    sha256 cellar: :any,                 arm64_sonoma:  "cf55e6264cdb059e125f04135563c955a6bf1c4cb61296a695d6f377f4d3306e"
    sha256 cellar: :any,                 sonoma:        "b4a1311842f86ca01d19907ae8faac25c0c9ce14dfab68d94261047508eaa888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "489594a6e2d3be56236dfabb192e57abd5e3fd95b8dc3e7cf77a65309835fdf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a087d54c5f0f78c384fe110baaac38a29d8d229a9c22b9dca894ad91aaa4344e"
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
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
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
