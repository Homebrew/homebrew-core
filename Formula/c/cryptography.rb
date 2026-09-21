class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/bb/ad/5d6702db60b1e40b41ef513b6967ff5848f307d50f8449baf1634f5908f1/cryptography-50.0.1.tar.gz"
  sha256 "5dd9bda1c12b4162f6ff568eeb5e0ff956c28d14406e875cfe8a63a2d414ff20"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 2
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "685a7fd0f220484dbca9377293b25db10ef1dc75cf6e52fbf0a68c16ef673e40"
    sha256 cellar: :any, arm64_tahoe:       "3a3d9012288bc2de959d6caa0adb6c9d884d9831e2b993d0986b028c7e285990"
    sha256 cellar: :any, arm64_sequoia:     "2c3a8e19720bf3dc3a009599b3ba9721dbcddf595ec43cf3968bffe4911cebb9"
    sha256 cellar: :any, arm64_sonoma:      "a2bbe4bf72908f9e0f6af66e8b7b3d9b7f1b91e73a21bbde61dd4ebdcea42bac"
    sha256 cellar: :any, sonoma:            "588cd93e1e2ed6a7fd968cae39572984e7b72705a4d21979a6584e24ab087e79"
    sha256 cellar: :any, arm64_linux:       "0bc1a4951e1f346ae8706537143fe9df42e82e6ed01ef35ec805b6b9867e5964"
    sha256 cellar: :any, x86_64_linux:      "7269b6147c5d4080b3ab9358468cb208cac317c2ed4e8520a49857cfb975ef9e"
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
