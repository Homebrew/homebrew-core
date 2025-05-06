class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/53/d6/1411ab4d6108ab167d06254c5be517681f1e331f90edf1379895bcb87020/cryptography-44.0.3.tar.gz"
  sha256 "fe19d8bc5536a91a24a8133328880a41831b6c5df54599a8417b62fe015d3053"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be6f02acb9eb7f6e715fa55c983f6ad218b4c014edec26b677aefabcef83a4eb"
    sha256 cellar: :any,                 arm64_sonoma:  "cd06588d93e725992a43e23fb77bb50eb715ca06a50c4aae06d5f846d9eac644"
    sha256 cellar: :any,                 arm64_ventura: "3de1c75ae46eea82e43ea65ee096e0288ee29b6c1d6aaa397414c27ce89e4e7b"
    sha256 cellar: :any,                 sonoma:        "e02bd55b285cd4a8d766bb7b7f20ebf3dabc02b2b70fbabd7ff63ef291f409c0"
    sha256 cellar: :any,                 ventura:       "f4819cccd593753bc338ee41eef2f3cda0446fdc7706ca0e38b564114c9e421f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f97c7235fcc92642f8cdc3dabf97f0611a940dfb19dbd3cc6901d982c94e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820d00b342ee8c60ea82e33899454492655e4cea419771d0c275486487a16e12"
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
