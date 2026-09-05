class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "605731e069cfa0e5cbfd3a40700f1bcee974ac1998df605f570f299034451a4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c871e8225c48abc5263997a0eeada3b1f835c86583957e292e1f4350de483e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835ad1c70c9e6582f024c6c9b5342891dee17d603333856c2e4a7f5d5174f4aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b9c5e58bbd4430aca342723e2eb5e69bc56839d9c7d177e629cc0267e194fcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09493725c3e6a89ff6267ee04d50b3da5ba5f24464e0bdecdfb7f51bb1c940f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af55bc0a2a276b0bf6352afbaf76c5655130e01abb51723c1847ce6fc53958f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
