class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/60/04/ee2a9e8542e4fa2773b81771ff8349ff19cdd56b7258a0cc442639052edb/cryptography-46.0.5.tar.gz"
  sha256 "abace499247268e3757271b2f1e244b36b06f8515cf27c4d49468fc9eb16e93d"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c17ad3cdef6f82e663e11212b0d07ec47afe24ff61158181eafc805df1d1a03"
    sha256 cellar: :any,                 arm64_sequoia: "133592bf44a0b1f8cc7a87d4137be7f8b335dc82a41bcb20b1321e91a0d480b8"
    sha256 cellar: :any,                 arm64_sonoma:  "67910064b42bd8428baeeee1e28389ba84827dd3da97c037e75762ce7a25b180"
    sha256 cellar: :any,                 sonoma:        "6af9ffaea0427a47fc13f6f24e140d31de098f7ad9c98c325ae4d0d890bb3194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "614c023162d73ec087334fb9f26575f3eb259dc05612765406a6dc43f4949edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8671d11df09062c03c9c632f26926f7a6f27bcc36a0b50aca18565cbe7d587c"
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
