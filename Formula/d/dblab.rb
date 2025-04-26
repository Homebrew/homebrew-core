class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.danvergara.com/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "dc038ca9c302c620323057ed163aff2b63bcb46f0cff00b712932105eafb7f96"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ae2a4b9246d1d21b45e9d10963910e36c8a334a7b2e8d4bf516693c63599dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa6b814f72e2e54a0b9a756cf8c284524f0562cc544d032435c62d53037506a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "134e0d328ec2998d7a22935c929099b4e502d2cbf5d9941ff8ff9ba969cec18f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb42cd63956aaf9df5fe5ba19b4be84fba7fa6fadecb98dca036ad13b52dc67c"
    sha256 cellar: :any_skip_relocation, ventura:       "d85cc6c1c9320778ee3ecf830ace47860afae6a05349652b3fcc840912b9579b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30673caf6a0ee08b4bc4e0c29bc9c301d57ebcac41555ab86f73fa371f2e6392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71983a413812c6652978eac769de2861c6b14ff2585fc46f821bf5b5bf29f70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
