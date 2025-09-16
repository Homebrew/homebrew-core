class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/80/ee/04cd4314db26ffc951c1ea90bde30dd226880ab9343759d7abbecef377ee/cryptography-46.0.0.tar.gz"
  sha256 "99f64a6d15f19f3afd78720ad2978f6d8d4c68cd4eb600fab82ab1a7c2071dca"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ecae7e523fd8cdf47fd530afae9ca676ef7e91596866008742325238d863734f"
    sha256 cellar: :any,                 arm64_sequoia: "7b775263cb1cefd9cff15d7cbaea3bb70c98024c4b9ccb28262491a9d9a6f44e"
    sha256 cellar: :any,                 arm64_sonoma:  "ff7594fd9f95d7fccf6cdf1e955d6b77c20b1c0ee1b5ea4f85db4bcdbc99551f"
    sha256 cellar: :any,                 arm64_ventura: "90efc0346983dc7501b5d133ddef5e75b6e74c9c68f647654524035fc4451f7d"
    sha256 cellar: :any,                 sonoma:        "e07d4631242aad91b1f3acd5d692188a2082555445f5c9f37734fba355c8c953"
    sha256 cellar: :any,                 ventura:       "06fd8987edc33f707e60d2bae23b1ca8274dbc30e9a780f3062b50172af9059c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c71e9b51779243bd490b1cfae7b90485cfff4eebfb721d25556080fd898bfa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "834018cb08ceebf4917e51f27e7c9ebf2635ddb7c0eda14f5ec62f8a6acf081c"
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
