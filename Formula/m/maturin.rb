class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "bee17a7c744d1f4a30477d4437adba5c97e31e989388a7946be205d0e9bcb9bf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "474802c1a31490c08bc39a4e70373e7887c95045e7f34ab0c0127aa87bd98342"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e99ddb1867c5256aad92413d75a298766aceaa188af1a972a1a8f56c2deef437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e775c1f7a60a0e7675ecbd14aae589af68d55dfeace730e8cc5aed952310f18"
    sha256 cellar: :any,                 sonoma:         "822eadf783293fe4f9b3d5ae430d193040c0c1f33c38670c261805aa7d49b492"
    sha256 cellar: :any_skip_relocation, ventura:        "9cd0107972db78f587b1cdb88328aa65bdde332f3346b00518ed78aef50d2807"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6b1fca36da3a5550c6d8c3d384a168b88f182983887016e2bc9100307f7a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5450d3d46d82480a41c6ed7e58e8bfce6ee6f5be93d5f0b46bd1698d50850ac7"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "rust"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/90/f1/70b31cacce03bf21fa645d359d6303fb5590c1a02c41c7e2df1c480826b4/setuptools-rust-1.7.0.tar.gz"
    sha256 "c7100999948235a38ae7e555fe199aa66c253dc384b125f5d85473bf81eae3a3"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def pythons
    deps.map(&:to_formula)
        .filter { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python)
      resources.each do |r|
        r.stage do
          system python, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python, "-m", "pip", "install", *std_pip_args, "."
    end

    # overwrite the minimal binary that pip installed
    system "cargo", "install", *std_cargo_args, "--force"
    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    pythons.each do |python|
      system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
      system python, "-m", "pip", "uninstall", "-y", "hello_world"
    end
  end
end
