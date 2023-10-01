class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ef/33/87512644b788b00a250203382e40ee7040ae6fa6b4c4a31dcfeeaa26043b/cryptography-41.0.4.tar.gz"
  sha256 "7febc3094125fc126a7f6fb1f420d0da639f3f32cb15c8ff0dc3997c4549f51a"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d69cb16ab2bcf78c47313d34158ee91dc6b3d0df52b42b34daff236aa91e71f"
    sha256 cellar: :any,                 arm64_ventura:  "204d71821d29792768eef5f00f1fc1941e1ff14d87f90a2b1953db5aab4b39c1"
    sha256 cellar: :any,                 arm64_monterey: "9227155a34256ddde7a983aa07fb7b999dff74eed2b55bd654be6c319fc26251"
    sha256 cellar: :any,                 arm64_big_sur:  "e485f428a5abb240089dbdd3e22557521b4a693d241c6a199de0a2449d7ae792"
    sha256 cellar: :any,                 sonoma:         "ec65a945555d11b7ec3bc1f10eda4fa48570f4368c75615dcd5dfe97086a9548"
    sha256 cellar: :any,                 ventura:        "f322799292cf5dcc247fa518c3f1079cc8640918e9b4bd6255d7cc124c9fae2a"
    sha256 cellar: :any,                 monterey:       "87220db8fedc1a46acb3cc7f8245036d0679c99ba5b38fc248ebeb7aed6a655d"
    sha256 cellar: :any,                 big_sur:        "b3454ec9a0804f932a53cb7a80da91239f42a1c6654cb5a0f7c5661bec5fd125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7e2ff7167929cc98f34140a04da2215c12d6073a7353cea658174a129a28bc"
  end

  depends_on "pkg-config" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "python@3.11"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/90/f1/70b31cacce03bf21fa645d359d6303fb5590c1a02c41c7e2df1c480826b4/setuptools-rust-1.7.0.tar.gz"
    sha256 "c7100999948235a38ae7e555fe199aa66c253dc384b125f5d85473bf81eae3a3"
  end

  def python3
    "python3.11"
  end

  def install
    site_packages = buildpath/Language::Python.site_packages(python3)
    ENV.append_path "PYTHONPATH", site_packages

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
      end
    end

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    assert_match "b'homebrew'", shell_output("#{python3} test.py")
  end
end
