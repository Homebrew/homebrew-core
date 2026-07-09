class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.298.0.tar.gz"
  sha256 "4472d171c35b7f94f3fbcf0423b4132989bc4a1250a899b5504ea205bebea7c6"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a2dcd9485aeb2ccb6834aef722bde76a89a09557ed5f00b121b16dcfdb284a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920df3cf00a9fbb4253259cb93e9fc4d77171e9d6fdf01f32742d2cc25cc45e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda737af950c839e0bb38aa11d481288b847ab7a5b546cdf88f4c60b8e7050dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1efc7b3ce3cfcd3b00d7ea1daf9293433cb8b2821fb876e4c0c54c2e88ba02ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7929f0c278034a6d73da988fa1ca115e66c81ae48601aa457bc748d63ae450c4"
    sha256 cellar: :any,                 x86_64_linux:  "5c50ca2fa5cf96a24da0d99ae86e34ccfc3e5ff196fe106ff915db38baf23476"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
