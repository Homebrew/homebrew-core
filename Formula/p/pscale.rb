class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.291.0.tar.gz"
  sha256 "3973805b0e54062ad83f52dca9316e014b2fb034ba7124fc69871577aad557b5"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbf28e0a663a0219156edbd8abe1435c3d5abe2b784a7c575e0760694af67226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6af7f35f9fe636e2bfbe3a11816a7db67de72ea9be31a6deef2e2dc41b7e532c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b744f9de2daa04cf3bc84d8de01c2f0e61765942511a21a5202cac3c832f1ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c526e56e7590b3bd8ec10e3c5ed47fc390872bd8c38b803c6b5029dfef35d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03f0b0c31284248421436d0194fec66ae9b8978d6e716bc6ee5a0e89bb7cff2"
    sha256 cellar: :any,                 x86_64_linux:  "ff1eaacc1a8fb722df29e0e625f6467912373e64a0ad421c9b63586661d70748"
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
