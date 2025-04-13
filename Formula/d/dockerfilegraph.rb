class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.17.11.tar.gz"
  sha256 "45a4cf8f6ee2510819fa2d3fa1d2525e8c7cde5c6f9fc4c0e12a9d2a8ec43f92"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2f06756c8b0633109ef6a7b53ae5ccabf5782ca6bd4635b69aad24d24ee2f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f06756c8b0633109ef6a7b53ae5ccabf5782ca6bd4635b69aad24d24ee2f84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2f06756c8b0633109ef6a7b53ae5ccabf5782ca6bd4635b69aad24d24ee2f84"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ff104186010a4abed01a1dd0901a917907bf422104daa628b2ba76507445a3"
    sha256 cellar: :any_skip_relocation, ventura:       "06ff104186010a4abed01a1dd0901a917907bf422104daa628b2ba76507445a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd7d7ec20c7bed42f090e8e5c8a95bee2bf8e8cde5c12f869f8839c709538f16"
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
