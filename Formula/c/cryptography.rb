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
    sha256 cellar: :any, arm64_golden_gate: "7b08c43ef8082788d616c510fe6d963310f0f7321b5454eaccde8a48db206688"
    sha256 cellar: :any, arm64_tahoe:       "f540b7d77d605b76c480649e9e89ae0670b1fc9f40c17adccf758faab4dec26f"
    sha256 cellar: :any, arm64_sequoia:     "63d1ec730ac0d0b9fdaf6f07f09054687449f481f823600f76a891aaec7799b7"
    sha256 cellar: :any, arm64_linux:       "b1094eeca891130ebb6109964115c97d59d78cd913c620b5275a07c20cf1dcd9"
    sha256 cellar: :any, x86_64_linux:      "a036915f635d12321a894e0d8ef314e25cc920b293171d73c610d5291a4218f2"
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
