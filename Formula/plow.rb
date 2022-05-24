class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bd57418d6842ae79a675ede027cd986d1e719edb163febfaec812d1a7cde4304"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950704a53979a9b0380eea38d28fbeb3a66a75c7c70b98cf520b27c173ea365f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1b8d9d830b45deefdd51587d41207e24be13ffa94243635285ad533d21cc539"
    sha256 cellar: :any_skip_relocation, monterey:       "120d725087be1cd4ca85f80eb276f6b09f137604fd8cfda088245c0f915dd2c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3809db189ca62f72ae3a9f984849d8189dff597e636a4b7b16665b7f91379abe"
    sha256 cellar: :any_skip_relocation, catalina:       "ae918fe58274757e2de7d7b530f6d651292f111d64d6156ebb6aa4a433c82a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ee6813afc113044fa3308ba268eabc9e85794cc72cd393b5494514fb292cfac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")
  end
end
