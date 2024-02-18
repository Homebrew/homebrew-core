class PythonCryptography < Formula
  desc "Cryptographic recipes and primitives for Python"
  homepage "https://cryptography.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b3/cc/988dee9e00be594cb1e20fd0eb83facda0c229fdef4cd7746742ecd44371/cryptography-42.0.3.tar.gz"
  sha256 "069d2ce9be5526a44093a0991c450fe9906cdf069e0e7cd67d9dee49a62b9ebe"
  license any_of: ["Apache-2.0", "BSD-3-Clause"]
  head "https://github.com/pyca/cryptography.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6c1c06863d05e22b3940e36ae9e224c94296bc14cef43b74d3de6cb68a56123e"
    sha256 cellar: :any,                 arm64_ventura:  "c9d97cd99e0073744e4fb6445f7a4f6a32e49fea109429379196e351208051df"
    sha256 cellar: :any,                 arm64_monterey: "899b9f9aab8b4127661812d4f01c1b352000d64f483f8d0d770469ac6271d0e4"
    sha256 cellar: :any,                 sonoma:         "1393b1525e1ad878c15cf5443e6fd86574ca5bd20398c48dd3aed72281df8464"
    sha256 cellar: :any,                 ventura:        "98d7728a39972d016185514e329baf087ce620b992cf17461a77dfb602fb2920"
    sha256 cellar: :any,                 monterey:       "c3d2898db37e9e78706eb7a5e73dbb54d62506e3f2fd64ecafee3fe160e91051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f739df53aa75bbd183429f48ecdb73686a71593f15a0f379846d1d13fd0ac15b"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/f2/40/f1e9fedb88462248e94ea4383cda0065111582a4d5a32ca84acf60ab1107/setuptools-rust-1.8.1.tar.gz"
    sha256 "94b1dd5d5308b3138d5b933c3a2b55e6d6927d1a22632e509fcea9ddd0f7e486"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from cryptography.fernet import Fernet
      key = Fernet.generate_key()
      f = Fernet(key)
      token = f.encrypt(b"homebrew")
      print(f.decrypt(token))
    EOS

    pythons.each do |python3|
      assert_match "b'homebrew'", shell_output("#{python3} test.py")
    end
  end
end
