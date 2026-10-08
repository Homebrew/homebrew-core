class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9d/af/182eb91b0df3fe75c4d9f26fe70684569566745f6ba7e5c9c73a862c5252/cryptography-50.0.2.tar.gz"
  sha256 "7b46165bb56eb4704e2eaaf86f3c940d19154535d9b0ca7d6d590b04060e00d5"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  revision 1
  compatibility_version 2
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "284a958cc39ab3a474f65ca0c8b8a80f999f7f788ff19e74ed4c5ed62e38fa12"
    sha256 cellar: :any, arm64_tahoe:       "012f55c89ec76bd3239cb52e4d07e40c57dc4d3ea872431618ce866a14ed2de8"
    sha256 cellar: :any, arm64_sequoia:     "81b88c5d226796cedfcfab25642fe8809e15c9c4d6b56fbe1521941fe1409d10"
    sha256 cellar: :any, arm64_linux:       "c02ddb995fb12408fbb83227b7fe9993e56eb29e8be0ae96200a2676a6a243e7"
    sha256 cellar: :any, x86_64_linux:      "20fa893400f3f3ffc73ac2bac813b2952dc9b6da89649b4c2660d3ca74de2e5b"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  # TODO: depends_on "python@3.15" => [:build, :test]
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
