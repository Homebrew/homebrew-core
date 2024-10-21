class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/0d/05/07b55d1fa21ac18c3a8c79f764e2514e6f6a9698f1be44994f5adf0d29db/cryptography-43.0.3.tar.gz"
  sha256 "315b9001266a492a6ff443b61238f956b214dbec9910a081ba5b6646a055a805"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d732628afbbcc5bbecc5ed544f06f5b14d5ac6cc0a4c8b1f701c174358a4b847"
    sha256 cellar: :any,                 arm64_sonoma:  "0265f0b12dfa59e1d6a3536fd9bac94a2821008ec7bbafbd67942abf74461f46"
    sha256 cellar: :any,                 arm64_ventura: "9056aaceeb056bdc38281fa26cc8a489cda9bde496ed7abb2b010cdba3789f6d"
    sha256 cellar: :any,                 sonoma:        "df405e9244b4dcd5ad2851b9c1ec22002564ad54faa33527278edf2b6aacdb13"
    sha256 cellar: :any,                 ventura:       "c26185f2ba0fc8d47ce9ce50692d0f262c749268909fdee9f82753930185f850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e930f8ae8dc0cfcb56100239bb6dc2c34c07f7a4d17487546ce646aafe227d68"
  end

  depends_on "maturin" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "maturin" do
    url "https://files.pythonhosted.org/packages/51/28/31a650d9209d873b6aec759c944bd284155154d7a01f7f541786d7c435ca/maturin-1.7.4.tar.gz"
    sha256 "2b349d742a07527d236f0b4b6cab26f53ebecad0ceabfc09ec4c6a396e3176f9"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/07/37/b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409/setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/d3/6b/99a1588d826ceb108694ba00f78bc6afda10ed5d72d550ae8f256af1f7b4/setuptools_rust-1.10.2.tar.gz"
    sha256 "5d73e7eee5f87a6417285b617c97088a7c20d1a70fcea60e3bdc94ff567c29dc"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV.append_path "PATH", buildpath/"bin"
    # Resources need to be installed in a particular order, so we can't use `resources.each`.
    resources_in_install_order = %w[setuptools setuptools-rust semantic-version]

    pythons.each do |python3|
      buildpath_site_packages = buildpath/Language::Python.site_packages(python3)
      ENV.append_path "PYTHONPATH", buildpath_site_packages

      resources_in_install_order.each do |r|
        resource(r).stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."

      ENV.remove "PYTHONPATH", buildpath_site_packages
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
