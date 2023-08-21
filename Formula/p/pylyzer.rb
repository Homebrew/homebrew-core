class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.40.tar.gz"
  sha256 "647702bf2e3f3cde18d4279dbe6f26287c4f39ee4e5b5365f44400b18b374c11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "623211eec50364ef3b4309796791329b321ae13ea61b4580a33321cb6511ce31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a9055e38bff18337dd3f3f0853e9edbce2e3449af7b1902db3aa1287045dc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "933f15aec0bf2577827de301d5ff4011d04ad7492864603040f33a78809d355b"
    sha256 cellar: :any_skip_relocation, ventura:        "98722ebfa1aea5dd7716ca2f7e1c0c1fb3e986bef9522008a3d7052c3994d919"
    sha256 cellar: :any_skip_relocation, monterey:       "95bbd704aa2f69714fdd0f34b6e4ff04e55728371adc5287d40f29521b225678"
    sha256 cellar: :any_skip_relocation, big_sur:        "1847aa9b6374fa2bd0c616de87ac954cd35f353b2086641f008f25b03d10e48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c889c0bff70ccd371fff5fb10bb96ba6d9230fd464cd1ee1f74cc8ccb71c845"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
