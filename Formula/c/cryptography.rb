class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/cd/25/4ce80c78963834b8a9fd1cc1266be5ed8d1840785c0f2e1b73b8d128d505/cryptography-44.0.2.tar.gz"
  sha256 "c63454aa261a0cf0c5b4718349629793e9e634993538db841165b3df74f37ec0"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c0211c9200c69fd4502e667237724d03d527c88de7c3e5c6c7a3b6a00ff9123"
    sha256 cellar: :any,                 arm64_sonoma:  "cfa9304a5f98a7da1e953631d7437f7808840d3b6bd0cf15fe5a2dd980b94fb6"
    sha256 cellar: :any,                 arm64_ventura: "4a91d6a22cfa163b579f32b5634fc2d4e7be496d336b2605152ed530468c4d5e"
    sha256 cellar: :any,                 sonoma:        "c1ca32d97f8b64dbce22e5a4a027d07b08258a764f68e59c545a335190a3bd9c"
    sha256 cellar: :any,                 ventura:       "91c7c7dd9ef494358dd5876d0cee55b111e163b330cc1331b0f409b2a1c125a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83903237b899b3476ec119742643567d961442c810c882bec8554266e88db8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26862dfd723ff5bb47a6b46e21c0acfc394cb431782e03d7751246e85143d56b"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # TODO: Avoid building multiple times as binaries are already built in limited API mode
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    PYTHON

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end
