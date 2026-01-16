class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "ec714828af7cf290fb69942c4bd65debf8d8fa08034f54389c3d32395c4951ea"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2d6f5248508be002ea9b56d3b809b75f6ada535e4a37ea24673f206ecda4b38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2d6f5248508be002ea9b56d3b809b75f6ada535e4a37ea24673f206ecda4b38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2d6f5248508be002ea9b56d3b809b75f6ada535e4a37ea24673f206ecda4b38"
    sha256 cellar: :any_skip_relocation, sonoma:        "3766061696d91ceb344926359e03aebfaf4f415682c0343a45ddfb940c855f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f62e4939b4b46e6336be38d8a6e4987e0fb6eb00a05a90a2314fc5c48a31d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d9c2859311dcbcde61fec9dae1d392966136425a7a28b277e6824b3928526b"
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

    generate_completions_from_executable(bin/"dockerfilegraph", shell_parameter_format: :cobra)
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
