class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/4a/9b/e301418629f7bfdf72db9e80ad6ed9d1b83c487c471803eaa6464c511a01/cryptography-46.0.2.tar.gz"
  sha256 "21b6fc8c71a3f9a604f028a329e5560009cc4a3a828bfea5fcba8eb7647d88fe"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27f94af3de8ec602be1c1701ad2e4cbc071e3b629a563d0048583fc5f0ebfdfa"
    sha256 cellar: :any,                 arm64_sequoia: "78490fbd9ff126f50fbf3f38a634cfa47c8e65c60af3bf4680ee762d08cf08e3"
    sha256 cellar: :any,                 arm64_sonoma:  "c022fe9b01a7c6e5371a6de2825613428911c7941057f2057a48fede5c5969c7"
    sha256 cellar: :any,                 sonoma:        "5c24010f656cbb6cc3988195910c2dc3cbb4ad2bad91d4dab10422644ec54701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68d284397302cc0ec153684c0cb8707c34a310bc615a4cb49f7f64bf410c374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf1e8747dc46840c0a4ee5e4a5b9f352cca8e9137f08dc21cc335ae59c39c578"
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
