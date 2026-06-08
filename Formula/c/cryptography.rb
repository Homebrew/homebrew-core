class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9f/a9/db8f313fdcd85d767d4973515e1db101f9c71f95fced83233de224673757/cryptography-48.0.0.tar.gz"
  sha256 "5c3932f4436d1cccb036cb0eaef46e6e2db91035166f1ad6505c3c9d5a635920"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f390e13da3334025fb729f65b672196343b04a6d579205660c2a1bb5a345899a"
    sha256 cellar: :any,                 arm64_sequoia: "cbd31e725f187032a667123ea6d27a68ead90a7151711edd52b263a12e448546"
    sha256 cellar: :any,                 arm64_sonoma:  "f0f58b7937ac50f59613830ef579f9badac06e41faf558830e7c7efb81af6b8e"
    sha256 cellar: :any,                 sonoma:        "ec66c3c7d05699b1d432927369f33945b4c8a2c9c5aafc2fb270d3aeceb6af69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd36cdf59e72fa25c75ac86c92a7d2874a423def0ed8b14a82445f1f69dc1350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56439765a7a5dab9417c496a290604a97ce16e7f4d96ffbbd5df7ed6ed23827"
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
