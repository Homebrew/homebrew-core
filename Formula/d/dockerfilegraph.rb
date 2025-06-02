class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https://github.com/patrickhoefler/dockerfilegraph"
  url "https://github.com/patrickhoefler/dockerfilegraph/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "8ddc643850658a6370e83012d3eace4a84db2052ad584ce98e7522edc2482a2f"
  license "MIT"
  head "https://github.com/patrickhoefler/dockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d8eda228923b6ce6aa85a62eb5fc5be66d987b086c42e2786237130dde2136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d8eda228923b6ce6aa85a62eb5fc5be66d987b086c42e2786237130dde2136"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77d8eda228923b6ce6aa85a62eb5fc5be66d987b086c42e2786237130dde2136"
    sha256 cellar: :any_skip_relocation, sonoma:        "0075c867275db0510e8b240895f09e3ebcfd52f87b42112a49293b1d8246a2b7"
    sha256 cellar: :any_skip_relocation, ventura:       "0075c867275db0510e8b240895f09e3ebcfd52f87b42112a49293b1d8246a2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc35a8424b5643897b6bfdfe7a1fe4e971a9b57a17a5210a42f3311c32f88d6"
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
