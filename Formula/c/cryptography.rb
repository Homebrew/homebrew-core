class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/13/1f/9fa001e74a1993a9cadd2333bb889e50c66327b8594ac538ab8a04f915b7/cryptography-45.0.3.tar.gz"
  sha256 "ec21313dd335c51d7877baf2972569f40a4291b76a0ce51391523ae358d05899"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3fb6f5223c9f1265ddd68f794e8038c527901fa56abb80663fc5e86fc8a05fcc"
    sha256 cellar: :any,                 arm64_sonoma:  "24493228adfe9008bf3c3f59242fc12e5b17e9ab8cfd53d0e477c53a990765ee"
    sha256 cellar: :any,                 arm64_ventura: "4d376d34b3eedff34c5fabb89ae5a0433b5a762196248b9ebdc02d03aea49e24"
    sha256 cellar: :any,                 sonoma:        "eea5ae79d7d81f752ea28a93a0663b71bb04154cfa7d7a490333712e5d535ac8"
    sha256 cellar: :any,                 ventura:       "7665dde8b15752cbafd3ecfaceeb6bf75715d0a892b1e5a12061ddbdc09ffb13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d28bb40f3f335167dc7184a040053c6da7ddaf695c81af3863e8b2974ae13b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455c3d883b4ed421c47241d2e124c92af89ff818fd243586dd895d7420abb9e9"
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
