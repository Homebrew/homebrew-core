class Pyflow < Formula
  desc "Installation and dependency system for Python"
  homepage "https://github.com/David-OConnor/pyflow"
  url "https://github.com/David-OConnor/pyflow/archive/0.3.1.tar.gz"
  sha256 "36be46aaebf7bc77d2f250b3646024fb1f2f04d92113d3ce46ea5846f7e4c4f4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01dd9e7751c3b6f7fbbc362d81d9710ddf015624feacfb8e218a4897e5aaae5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f564d5e5cd3db39ed6f74016b81c68bc85ac9984e37e1ed104b411c24027359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e49056e5aca63db575e0666caea6b7d9a49e2d1a96e5875b4f635996ef7dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "669b62cb0547ffc164ad936a930cb0108052b7d1f92f7e6c7f5a25a04cb2167f"
    sha256 cellar: :any_skip_relocation, big_sur:        "06c81ecf12284c17a47d8701ff9bff608809038943ae473e36af80d166faf956"
    sha256 cellar: :any_skip_relocation, catalina:       "33cca1590360162f960d97c4544b0ee0bb3449e55b43d0f2f7f652fd5f0b7be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63dcd026d508c2db194de790d0f3c9e5d7f6ca40ef6e4c294f00d2a42778201"
  end

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    pipe_output("#{bin}/pyflow init", "#{Formula["python@3.9"].version}\n1")
    system bin/"pyflow", "install", "boto3"

    assert_predicate testpath/"pyproject.toml", :exist?
    assert_predicate testpath/"pyflow.lock", :exist?
    assert_match "boto3", (testpath/"pyproject.toml").read
  end
end
