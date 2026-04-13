class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "7593483acf26aefb42b2bc9eeea1d42d2262732d4c88298d1dff78c52278c48f"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ffb6f777419e29eaaa18813927f69177c44783ab45883fc1580f6e62d2a4db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ffb6f777419e29eaaa18813927f69177c44783ab45883fc1580f6e62d2a4db7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ffb6f777419e29eaaa18813927f69177c44783ab45883fc1580f6e62d2a4db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b26d495598088cb22b7149734a9f5714d22da02edc921dc0d57c4d4a7ef85b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56434b1d10e42f97edbe1cd176786fd86f91307f8a468d2c46425f16a688ba58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "693ecc915aec2a80cb833d2ee5d0975f302e147bdbf2dcafcc7a11c85df9e5cd"
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
