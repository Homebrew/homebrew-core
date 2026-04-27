class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ef/b2/7ffa7fe8207a8c42147ffe70c3e360b228160c1d85dc3faff16aaa3244c0/cryptography-47.0.0.tar.gz"
  sha256 "9f8e55fe4e63613a5e1cc5819030f27b97742d720203a087802ce4ce9ceb52bb"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  compatibility_version 1
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9e4492020f8d0ffe6fc092c5a3247a50f3bda5d0f92c6a355317973601f949f"
    sha256 cellar: :any,                 arm64_sequoia: "5a0443703ed6085ceb1421f1aed938cd427b5c20270b5b5ac26ff7260347d20c"
    sha256 cellar: :any,                 arm64_sonoma:  "b5462eb235bd2fd99b0ba6b5fba6fec395f1925a88702203f058f5d266ff4faf"
    sha256 cellar: :any,                 sonoma:        "9d056d8be0a6d7c7148745d834835df41bbc517ae538bad8a414dde0333108cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e441ebb2fea5cf4370915537d9e2985445eeb1235332c87476fd8d41f71bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d13402b0bd126158028a22e4e9abcb84b6e1459c31b0d61725b654ce2e863e3"
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
