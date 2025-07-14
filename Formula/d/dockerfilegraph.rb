class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "1e1013c9482e7cf55b5e4bb9ca7fefbab02c1cb311220b86e665a1ac3a4f73b7"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3cec0eb74fbe428aa3c49ece64e51a210aaaeebff2d26d492ef3b88c020f709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3cec0eb74fbe428aa3c49ece64e51a210aaaeebff2d26d492ef3b88c020f709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3cec0eb74fbe428aa3c49ece64e51a210aaaeebff2d26d492ef3b88c020f709"
    sha256 cellar: :any_skip_relocation, sonoma:        "f43622e507c6c2f0774f052a201c7cf822e88cea83a1951c27b242e9001a97fc"
    sha256 cellar: :any_skip_relocation, ventura:       "f43622e507c6c2f0774f052a201c7cf822e88cea83a1951c27b242e9001a97fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f0f1a774431f48b1facbf9f56bd5526e8aa2ad877c5f9dd27e3319caa3ab8c"
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
