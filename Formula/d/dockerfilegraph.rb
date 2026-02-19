class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "a855b60a0a538f95ca73c5d365f05a2646d847a621586173cc9075bb767bc4ce"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "057ea586a131defd8c65ba4a8251202b6e50fd233e7fcfa5a15fc5b257380f05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057ea586a131defd8c65ba4a8251202b6e50fd233e7fcfa5a15fc5b257380f05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "057ea586a131defd8c65ba4a8251202b6e50fd233e7fcfa5a15fc5b257380f05"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c34bba87614ba4202ff02f4d01e074a629da57330f79cb817f0b8ad33746ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e9e922b63402bdd985ec2ee41cadc554ce59d240e050c995d3cf9c7c12fe123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45976fbf38aa7b319badbf236c1e25ec4a0f3a7d7f3fede98b50b95857de536"
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
