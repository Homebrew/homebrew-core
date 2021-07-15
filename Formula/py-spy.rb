class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "5a75df5dd1ed683b80bb6a89007b4fe9f7f0a5129cf613ff70e94029d11e87a5"
  license "MIT"
  head "https://github.com/benfred/py-spy.git"

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/py-spy record python3.9 2>&1", 1)
    assert_match "This program requires root", output
  end
end
