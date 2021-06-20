class Pyflow < Formula
  desc "Installation and dependency system for Python"
  homepage "https://github.com/David-OConnor/pyflow"
  url "https://github.com/David-OConnor/pyflow/archive/0.3.0.1.tar.gz"
  sha256 "c29ee89255446b9e50024f749d32b5dbe7e19ecdfbbe382bf518ace271ebc402"
  license "MIT"

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
