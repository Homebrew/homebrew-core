class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6e6f85402045105220f9c2d91aa3d953c46a3093e530b2d55be8879e00b68c31"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "628266f879b557df20968ce15f85f960c9e691daada3915df233273ae9e3aa86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f07003e2d6936dfe1f767b323116c26937728cb4610c857302ac547ce25af7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c9a837e831aa49b52762e46162fb9cabe72288c0314ad825d8d9cadfa34dce"
    sha256 cellar: :any_skip_relocation, sonoma:        "70edd6b1c969cbddc1b8d855fab25064e33ea4006dd2350f1464c63047ecb0ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "123daa70eec37933666e37dd4f6cbcce75777a73c9f287bc2d1d39e8c800b440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614638615f48e1bf0e4d335927a9145c9e1ce0961f7f914afbdca18a97f1767d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/marmotdata/marmot/internal/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match "marmot v#{version}", shell_output("#{bin}/marmot version")
    assert_match "MARMOT_SERVER_ENCRYPTION_KEY", shell_output("#{bin}/marmot generate-encryption-key")
  end
end
