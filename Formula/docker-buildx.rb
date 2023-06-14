class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.11.0",
      revision: "687feca9e8dcd1534ac4c026bc4db5a49de0dd6e"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e4db3bb9aebdd17f45d9a47d6182e2614ea7d7d5df354f9667126820a866b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e4db3bb9aebdd17f45d9a47d6182e2614ea7d7d5df354f9667126820a866b93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4db3bb9aebdd17f45d9a47d6182e2614ea7d7d5df354f9667126820a866b93"
    sha256 cellar: :any_skip_relocation, ventura:        "540923f910b79acf8472c001c6b6e92cbcf3ca9d643c04d548de5c5ad17685cf"
    sha256 cellar: :any_skip_relocation, monterey:       "540923f910b79acf8472c001c6b6e92cbcf3ca9d643c04d548de5c5ad17685cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "540923f910b79acf8472c001c6b6e92cbcf3ca9d643c04d548de5c5ad17685cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8330390fafbb701acf35ed232a5d493e3fd9adcd0a80c215bcd68ce59f761332"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-buildx ~/.docker/cli-plugins/docker-buildx
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
