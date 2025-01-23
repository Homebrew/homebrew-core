class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/91/4c/45dfa6829acffa344e3967d6006ee4ae8be57af746ae2eba1c431949b32c/cryptography-44.0.0.tar.gz"
  sha256 "cd4e834f340b4293430701e772ec543b0fbe6c2dea510a5286fe0acabe153a02"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12226755e51fb0906b84524b8e05f888d934746b1b1789e4bf75d5b90f528c86"
    sha256 cellar: :any,                 arm64_sonoma:  "e79a38ec32ea9db4d0c3174a987446a2d48e50dece37717fb7f8347cc5bc6691"
    sha256 cellar: :any,                 arm64_ventura: "830acdf85a5db66c17d4b5893016423c64f8675d45227d7074cf43fb079cc77b"
    sha256 cellar: :any,                 sonoma:        "5cfc7e120a2727ca8de2bc1fea449a0bc8b8a691e907e5d5d34d5ae1b5097719"
    sha256 cellar: :any,                 ventura:       "6b724677da0c6cd73272b95e3143a069c4b3ce776d2bf9c1b6b94355cde4928a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0729bfb2754121d45a3b79bcdc1c32515f02b4e5ab675f7ac89b3c4c6f536be"
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
