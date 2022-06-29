class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx.git",
      tag:      "v0.8.2",
      revision: "6224def4dd2c3d347eee19db595348c50d7cb491"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c64de4f3c30f7a73ff9db637660c7aa0f00234368105b0a09fa8e24eebe910c3"
    sha256 cellar: :any_skip_relocation, arm64_linux: "304d3d9822c75f98ad9cf57f0c234bcf326bbb96d791d551728cadd72a7a377f"
    sha256 cellar: :any_skip_relocation, monterey: "95303b8b017d6805d35768244e66b41739745f81cb3677c0aefea231e484e227"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=#{version}
      -X github.com/docker/buildx/version.Revision=#{revision}
      -X github.com/docker/buildx/version.Package=github.com/docker/buildx
    ]

    system "go", "build", "-mod=vendor", "-trimpath",
      "-ldflags", ldflags.join(" "), "-o", bin/"docker-buildx", "./cmd/buildx"

    doc.install Dir["docs/reference/*.md"]
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-buildx ~/.docker/cli-plugins/docker-buildx
    EOS
  end

  test do
    assert_match "github.com/docker/buildx #{version}", shell_output("#{bin}/docker-buildx version")
  end
end
