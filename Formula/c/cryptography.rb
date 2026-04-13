class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/47/93/ac8f3d5ff04d54bc814e961a43ae5b0b146154c89c61b47bb07557679b18/cryptography-46.0.7.tar.gz"
  sha256 "e4cfd68c5f3e0bfdad0d38e023239b96a2fe84146481852dffbcca442c245aa5"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d43b0d3b147ca50564cfba22f64542064c39c6e26cb424a163d4d736c9a5f3b"
    sha256 cellar: :any,                 arm64_sequoia: "8cc97e1422c73bfdb9e1e8f0b7cf541f586f652b62f306920295db066d683022"
    sha256 cellar: :any,                 arm64_sonoma:  "deb86e70cbbf84bbcfab0b2db91c6724a6e3067018fb1163dc6ae12736a14abe"
    sha256 cellar: :any,                 sonoma:        "77ad383d5926c6be04fb8744a435d6baf7d22fb30e353fc55b311491d2f68f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7730c451d5d7c0f9d501911a64cdf358bce3ff87ee8d38d31ef763b768375e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bad0ca4c5e73d94f6016d7ba9b0252a275d82450841487aadf9389d5365df8b"
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
