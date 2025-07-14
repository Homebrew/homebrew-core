class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/95/1e/49527ac611af559665f71cbb8f92b332b5ec9c6fbc4e88b0f8e92f5e85df/cryptography-45.0.5.tar.gz"
  sha256 "72e76caa004ab63accdf26023fccd1d087f6d90ec6048ff33ad0445abf7f605a"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "daba4bfadcb353312cfb0b10511a79a0d4046e768e866c89ef688142eb006cee"
    sha256 cellar: :any,                 arm64_sonoma:  "10b86969f33a296807d807147bea8e6f17588b5521c6319b26ae819a0bba9681"
    sha256 cellar: :any,                 arm64_ventura: "331ff1134fca001052807d475e5da8e1de71b966b8cc9f2c6d20930de24f0247"
    sha256 cellar: :any,                 sonoma:        "dbdc6555f631d1c0a59c86c34ec10ed13e720013ec37a37d63f3f565b27a1085"
    sha256 cellar: :any,                 ventura:       "e89a800bfc69aefcd12826d27004ad35d2cd2823b031f34c875efe4a3872326d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27e3a142003979df5c0b78b1a9fe84d183832f4a74c9b1359ca144ac8c112208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62406c7fd4bf90a395c86ff34eacc03f20bc283f625d3b80cf6ac044e4f5af7f"
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
