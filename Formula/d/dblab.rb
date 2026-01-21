class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "fdcf88a1b4bbfea0d401a8ed13b930408e6fd85bde341565cb7a7a649a274d94"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d43adf54e6fbfe3f960a9bd4bf528858dffa1bb81a851b6a4ca5aef05ffc140c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cea1288d11278beda5ccc60f3a408bda994a6369419bbbec5a0d2c95f2e03db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecbc95d339025267a8542c8098302c605ff3321be1e589df9f9c965cfccbca2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e920c103d4854a1451be086592028bd97510f06ac1c8eac56d0cab17a9307ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd7b61a08cb70653413b4db05ebe47e49215bd2c23e8d23a3cc1a973e0ef2d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5737a66d22c3fb01cf61104de5d8addbf9935947cfd8fddfde71792fca629dc1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
