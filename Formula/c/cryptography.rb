class Cryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9f/33/c00162f49c0e2fe8064a62cb92b93e50c74a72bc370ab92f86112b33ff62/cryptography-46.0.3.tar.gz"
  sha256 "a8b17438104fed022ce745b362294d9ce35b4c2e45c1d958ad4a4b019285f4a1"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48db931aa0ccdb25a9b4fa9c3af4641c555e10952d62ef75a8be9c0f54a0704b"
    sha256 cellar: :any,                 arm64_sequoia: "cfd504439fd34e6bdf82e3f06c24b275ff748ccdb82b650999da3203e7f5e513"
    sha256 cellar: :any,                 arm64_sonoma:  "3c2fd65437f27093fa4ab4986c3a046627fdadf1d615fd388457a3d279b0eb50"
    sha256 cellar: :any,                 sonoma:        "1bb86940ea28a29574da8f153d959e9df4177848c8b5da1381f6408f6212bcb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b6143dff90f57c28d5d50d91b67927bac7dfda96c101ede76be85ec7936bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf9589e0106293376c67e6fda53bab16f494565a74b1608c05a9357f08edcb0d"
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
