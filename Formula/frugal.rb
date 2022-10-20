class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.5.tar.gz"
  sha256 "4b9c6e7d797c00e46271812e24d0f41d9f2b2acd7c054eeded05d87fce0304e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9775040fae649e71041ba484e965c008bc90c3a094d3cd7517172fd91ce08fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9775040fae649e71041ba484e965c008bc90c3a094d3cd7517172fd91ce08fd"
    sha256 cellar: :any_skip_relocation, monterey:       "6a4f64f7ae9c1cd5e68b7d0daa400c1c84f088feaa3747a0fdf79d63b6e2bcb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a4f64f7ae9c1cd5e68b7d0daa400c1c84f088feaa3747a0fdf79d63b6e2bcb9"
    sha256 cellar: :any_skip_relocation, catalina:       "6a4f64f7ae9c1cd5e68b7d0daa400c1c84f088feaa3747a0fdf79d63b6e2bcb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95c2b57f57b0b2e3fed697089f046f46274c544ce691c765e43189e8fb96c885"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
