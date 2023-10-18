class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ef/33/87512644b788b00a250203382e40ee7040ae6fa6b4c4a31dcfeeaa26043b/cryptography-41.0.4.tar.gz"
  sha256 "7febc3094125fc126a7f6fb1f420d0da639f3f32cb15c8ff0dc3997c4549f51a"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  revision 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9acb1d0b08ffeba7d234fc6ab541c3282511e7d27be0fb1e973ba662362545f9"
    sha256 cellar: :any,                 arm64_ventura:  "008403e77eef739ee0cc619ba9fdcdaef63ce4ef38d0164c87eaa6244a78378b"
    sha256 cellar: :any,                 arm64_monterey: "9d92672b1154bacaf1799b5fc93c7d15b4a9c171d60f0e6901077005b4eb85ff"
    sha256 cellar: :any,                 sonoma:         "38f7fcee1124605ba68461b53256689cee4cf3985ddd17c60ff2fd384a761bdf"
    sha256 cellar: :any,                 ventura:        "febf8084de667e0e940517efa36f1e8cbe89e3950b89bc586b60dc9f06f114d6"
    sha256 cellar: :any,                 monterey:       "882876e694786b83c28bb43fc07357e1dd36d424a902a62c0aca99393cde9b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ddf1c56853e59509abc47c89155f7b5363cb5c8c8bb1c43305441e7443aa42"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/90/f1/70b31cacce03bf21fa645d359d6303fb5590c1a02c41c7e2df1c480826b4/setuptools-rust-1.7.0.tar.gz"
    sha256 "c7100999948235a38ae7e555fe199aa66c253dc384b125f5d85473bf81eae3a3"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end
