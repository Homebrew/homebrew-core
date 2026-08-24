class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/de/41/6cbdcf9142d00fe82836fbb51e503e58088575cf7a0fe1dbff6695bf0840/cryptography-50.0.0.tar.gz"
  sha256 "eeac2acb5a20ed25e0ad6d1df9891a520b78b404266b6d11778f25d5d691a6c9"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 2
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1c0d605396f75648f713e109c6b58df9e2aa8d83691ac85524acf2f5577766f4"
    sha256 cellar: :any, arm64_sequoia: "4d5ae554fdd4a50163aeea97cbb383b6bfdfedd60e53c3f7971a8c9d685e7a57"
    sha256 cellar: :any, arm64_sonoma:  "590e1a7e858f2d85d15fc05d6f95169ca89e8c29ef14820060a791f4555c99d7"
    sha256 cellar: :any, sonoma:        "927b4503b82cb595b74e1ddd89009df95fa3cf868a834c5e4af81df9a7291885"
    sha256 cellar: :any, arm64_linux:   "2e8edd67ad7f215c6022156e824cc8367d59b89437b9d9cdc0cddfba4e121c49"
    sha256 cellar: :any, x86_64_linux:  "2ad80d50545b09490aa1a0b7a805a96fc3465bcc5d84193ef731dc79745292b0"
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
