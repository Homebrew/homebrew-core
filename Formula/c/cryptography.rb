class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/de/ba/0664727028b37e249e73879348cc46d45c5c1a2a2e81e8166462953c5755/cryptography-43.0.1.tar.gz"
  sha256 "203e92a75716d8cfb491dc47c79e17d0d9207ccffcbcb35f598fbe463ae3444d"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  revision 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae96ccba63bdbe1eff0b7ea6e0b078f25fe5096f984c21438544637f7529aa41"
    sha256 cellar: :any,                 arm64_sonoma:  "118a0fa32bf78f22a2f7608a60b74b0973c3843c9b784aba9163c030d3125c37"
    sha256 cellar: :any,                 arm64_ventura: "00b9970c80945b39299d5277711ecfa86581d011712bbb57af8ab658ba04f2d5"
    sha256 cellar: :any,                 sonoma:        "9dbcef69a8eaeb9c03c6ad42dd0dcd9ce4a3eaf16305956a1b197417ce78f4b6"
    sha256 cellar: :any,                 ventura:       "7225b21872c1e684420016b3fcf16d576044debc04a80fb96f579015b5d275c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f617322ca036b4c6390bc7fa4b84128382eaf59b6853ebe57b8f2c29b56f2dc"
  end

  depends_on "maturin" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/cb/e754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96b/setuptools-74.1.1.tar.gz"
    sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/b8/86/4f34594f21f529623b8650fe729548e3a2ad6c9ad81583391f03f74dd11a/setuptools_rust-1.10.1.tar.gz"
    sha256 "d79035fc54cdf9342e9edf4b009491ecab06c3a652b37c3c137c7ba85547d3e6"
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
