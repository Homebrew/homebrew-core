class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "e3b8a1adf6d57803b0cd688fa7c493cbe741fb87b52c04494d57dc9e8fb457b1"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dacf571d119f34e01607d4f085de115bedd7be0c1a78281fc67d4130b143c0c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "553cad861ae161216d7f79184e17faa5080a8477279b6cb6a7efcdabb06fd59a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de67bd95cabed03a1b6ef4fe09b32bb7046d1f4231c2fd594ba4daf15d1a0d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0484a90ea64f54b8222cdbbbe4b2283f8b4951a4852896d081854211d1e15517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f1adbc28012608477636bda47ad156224cd02612ac645ee69c5137b50aa6481"
    sha256 cellar: :any,                 x86_64_linux:  "7824de83dcc3ae81276cfaa9ed2f29cfc8590bc30d0daed8476f27701ee1b6f3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
