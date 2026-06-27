class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1f/99/d1c90d6041656cc6ee229dc99cd67fd0cd5aec3c5f7d72fffc27cc750054/cryptography-49.0.0.tar.gz"
  sha256 "f89660a348f4f78a92366240a61404e337586ef7f5909a2fef59ca88ef505493"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 2
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a908c19e09612e76cf34adf3257c4645490b3286579f603c37b4ce9db7d64d58"
    sha256 cellar: :any, arm64_sequoia: "9103a017bd8e8ae8368d16cb5cae817918606955daf10ae476af36b2d5f02c8e"
    sha256 cellar: :any, arm64_sonoma:  "68e119242f2013e50d71b01fd0b1018456a6731083d3e06c5e7fd00f4b8b65c3"
    sha256 cellar: :any, sonoma:        "4a558a133a98bb863f575dab175809ffb46056d370b0dcf2716261110844fc96"
    sha256 cellar: :any, arm64_linux:   "2db385fac389eb7d2bb158998ac61345816398cedad16c46b4b9c082d8b8bc1c"
    sha256 cellar: :any, x86_64_linux:  "00541f724f24cf56e92779ae7ecaedea2187edaee4d9ac8508bd1a5ab06b36aa"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  pypi_packages exclude_packages: ["cffi", "pycparser"]

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
