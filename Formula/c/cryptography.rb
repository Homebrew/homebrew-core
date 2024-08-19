class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/69/ec/9fb9dcf4f91f0e5e76de597256c43eedefd8423aa59be95c70c4c3db426a/cryptography-43.0.0.tar.gz"
  sha256 "b88075ada2d51aa9f18283532c9f60e72170041bba88d7f37e49cbb10275299e"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f63358344349cb2cbe451b3e268f30062fef70549f90fa59b00cef233f9177a9"
    sha256 cellar: :any,                 arm64_ventura:  "2bace84ec8a8756ebb3d6827193d906c0f774e60c3ae256a2db48688d166c328"
    sha256 cellar: :any,                 arm64_monterey: "69c35ff5a5f9655e3803231bf0e93730f6622a86357fda453fb7ac0512fc0e61"
    sha256 cellar: :any,                 sonoma:         "55ad8089aa466bde1e15753953738fe0644c46a22f00334ef46e1f8629fc8cba"
    sha256 cellar: :any,                 ventura:        "0f2b5d6e6d27f3741b56a4773f3a62daf06c16c9926ae10fe65677d38d2bb2aa"
    sha256 cellar: :any,                 monterey:       "b657b927d664c836db4f6701884b8f12879284f370508f972ae1e55ddffc516a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a098109ae8af3903feb995d819859407f5580156e5cf5b68b7666e1ae8f6903e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/80/da/a4bbd6e97f3645f4ebd725321aa235e22e31037dfd92caf4539f721c0a5a/maturin-1.7.0.tar.gz"
    sha256 "1ba5277dd7832dc6181d69a005182b97b3520945825058484ffd9296f2efb59c"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/32/c0/5b8013b5a812701c72e3b1e2b378edaa6514d06bee6704a5ab0d7fa52931/setuptools-71.1.0.tar.gz"
    sha256 "032d42ee9fb536e33087fb66cac5f840eb9391ed05637b3f2a76a7c8fb477936"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/9d/f1/2cb8887cad0726a5e429cc9c58e30767f58d22c34d55b075d2f845d4a2a5/setuptools-rust-1.9.0.tar.gz"
    sha256 "704df0948f2e4cc60c2596ad6e840ea679f4f43e58ed4ad0c1857807240eab96"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV.append_path "PATH", buildpath/"bin"
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      deps = %w[setuptools setuptools-rust semantic-version maturin]
      deps.each do |r|
        resource(r).stage do
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
