class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "5a75df5dd1ed683b80bb6a89007b4fe9f7f0a5129cf613ff70e94029d11e87a5"
  license "MIT"
  head "https://github.com/benfred/py-spy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60f64ee1e23c1555051741dab484fb42b01af95b9f0e6fb688f63cdca1e4d3ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "90ae7759bccfacfdc8ef74841433b499a459db0078203924222da77bc0336179"
    sha256 cellar: :any_skip_relocation, catalina:      "ab26fd2d9cb6ec5a72ea7ff9d83b912c305ec9e4d3080073ecf39361b649cf68"
    sha256 cellar: :any_skip_relocation, mojave:        "f425133a9a9ee7f9565df6f9f4ce9ce6e5afa6eedbc2d2bafac0d055f4938018"
  end

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
