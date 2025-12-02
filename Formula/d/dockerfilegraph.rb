class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "6a8881599851c683401679ec597be7ee235dc3b21521d03d278980bc5811fca7"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2a4bdec5bf0a8ac4e0a78c7c1eb3f59f346ce1a6332b07e24d0f8fa9d00812c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a4bdec5bf0a8ac4e0a78c7c1eb3f59f346ce1a6332b07e24d0f8fa9d00812c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2a4bdec5bf0a8ac4e0a78c7c1eb3f59f346ce1a6332b07e24d0f8fa9d00812c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a4f66f2c6b8d19626f993de642d7c7d0edd5b421c460dd8a9d5cc8979e0dfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34af91fcb654a496f3a6b1b4922f8f816353ef3ab4945306344edd8dc0bde255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71254a91804c45cf519859dd644cd22e3da9d8eadf6b12e984ea916acc83349c"
  end

  depends_on "go" => :build
  depends_on "graphviz"

  def install
    ldflags = %W[
      -s -w
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitVersion=#{version}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.gitCommit=#{tap.user}
      -X github.com/patrickhoefler/dockerfilegraph/internal/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerfilegraph --version")

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine AS base
      RUN echo "Hello, World!" > /hello.txt

      FROM base AS final
      COPY --from=base /hello.txt /hello.txt
    DOCKERFILE

    output = shell_output("#{bin}/dockerfilegraph --filename Dockerfile")
    assert_match "Successfully created Dockerfile.pdf", output
    assert_path_exists testpath/"Dockerfile.pdf"
  end
end
