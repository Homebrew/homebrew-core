class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.55.0.tar.gz"
  sha256 "da46e7e70f09a015f5a7dbd6fb9b3efaed4495b1fc08d986f7ab64d8b02dd6b8"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d88156a4ff7fdea00a11c10ba4955f5373893e99075b6dca0a99db964d131ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d88156a4ff7fdea00a11c10ba4955f5373893e99075b6dca0a99db964d131ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d88156a4ff7fdea00a11c10ba4955f5373893e99075b6dca0a99db964d131ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f1ec063841d742a1f8506351c36e1bd8cb540cf015825390676b4b7a700c61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933a07b8e49c6bc08c114ccb71d5ec460e0d5ec965d4c71f3b3d02b910350057"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
