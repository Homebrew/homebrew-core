class Pyflow < Formula
  desc "Installation and dependency system for Python"
  homepage "https://github.com/David-OConnor/pyflow"
  url "https://github.com/David-OConnor/pyflow/archive/0.3.1.tar.gz"
  sha256 "36be46aaebf7bc77d2f250b3646024fb1f2f04d92113d3ce46ea5846f7e4c4f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8bf0ab452a96728d8ae1224b87c5a829a1baead24cffeaefd49458b806e3f70e"
    sha256 cellar: :any_skip_relocation, big_sur:       "479bb582e912848fd7d1b7e5a68bedef006fee399cd4ef2411cdbe68be4dc734"
    sha256 cellar: :any_skip_relocation, catalina:      "154a512756d034be9fee4e57de8327c7c759a80dd10e330b9961ad08a430664b"
    sha256 cellar: :any_skip_relocation, mojave:        "04c33c1225ebdf590edbc3cb6c399f53e799d29535cf777baed2413b2ea0f773"
  end

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    pipe_output("#{bin}/pyflow init", "#{Formula["python@3.9"].version}\n1")
    system bin/"pyflow", "install", "requests"
    system bin/"pyflow", "install", "boto3"

    assert_predicate testpath/"pyproject.toml", :exist?
    assert_predicate testpath/"pyflow.lock", :exist?
    assert_match "requests", (testpath/"pyproject.toml").read
    assert_match "boto3", (testpath/"pyproject.toml").read
  end
end
