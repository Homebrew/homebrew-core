class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9d/af/182eb91b0df3fe75c4d9f26fe70684569566745f6ba7e5c9c73a862c5252/cryptography-50.0.2.tar.gz"
  sha256 "7b46165bb56eb4704e2eaaf86f3c940d19154535d9b0ca7d6d590b04060e00d5"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  revision 2
  compatibility_version 2
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e418279b26e607bfb4512bc15c31e551e228b015becb407e548e9c6d868fb2bf"
    sha256 cellar: :any, arm64_tahoe:       "d79b516ffa80d7a8d12da5b3ff55fc6c1b029ec6f424e8525c6d32836c27516d"
    sha256 cellar: :any, arm64_sequoia:     "6ba0ff5affb3b1780347d85fe626a18954fd67ef9d3bc40ede1d0d1645d0e640"
    sha256 cellar: :any, arm64_linux:       "bf8b722462f50b45ad778e496bf0df5f1e8ad402968727f50f723a00e15274f6"
    sha256 cellar: :any, x86_64_linux:      "9cbb611577a88bfebc5751fdfad7f109b1e6bcf040b3a4d008c07d7c5ca3be0d"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@4"

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
