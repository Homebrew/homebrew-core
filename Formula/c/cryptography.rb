class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a9/62/e3664e6ffd7743e1694b244dde70b43a394f6f7fbcacf7014a8ff5197c73/cryptography-46.0.1.tar.gz"
  sha256 "ed570874e88f213437f5cf758f9ef26cbfc3f336d889b1e592ee11283bb8d1c7"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cdce37501be8cafb9f73675214abb5733c1df43fb99d27a6e56f0746c8360a46"
    sha256 cellar: :any,                 arm64_sequoia: "e554d90bd6b50319d53129fc94f84e46065c1d941fa0f7ed2073c289d8d8c550"
    sha256 cellar: :any,                 arm64_sonoma:  "22dacc09c15184a398b40faf45240fcd1185950b751a5ebb8e113d23f6b7e9d7"
    sha256 cellar: :any,                 sonoma:        "7c63f4aff1eb97591b4e0f20098fe948666486edab52d2275e85ad22fe4a87d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8033e7dd333d5aaa7251d965d62867f8a50543a34e045ceb3cc1dc139ef9351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "237716c109b28a73b14c7c7e7bf4ab4debd2c833fe2cbe45252155477741e943"
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
