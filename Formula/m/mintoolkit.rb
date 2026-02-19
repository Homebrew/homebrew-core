class Mintoolkit < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/mintoolkit/mint/archive/refs/tags/1.41.8.tar.gz"
  sha256 "c48a44d34622d1baa3a8245f19b5659d7d8fa4435cc51c5e2f492916b8e8ea25"
  license "Apache-2.0"
  head "https://github.com/mintoolkit/mint.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46b2ab6b6a9737f6cdd6d71144c5761c0d81800a31dd71c97d3be9833a089940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e5e2ea92bf195a054bdb7a00b94a6200a68633883588327ef58d52198f57c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fab60cb96ec058012b9b5731408373dcbd897ec6ba173b90551e92e39289d1df"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa22f8c22cf3b4dcfe49dca2ed42b3c5c9b2c11276f1e37a5eebee5aed27ef63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6e2ebb12043106ffd49dc4b23a5ca82e5517cd34acb67227a654438ceafa76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb4218cf724bbe79c844c3dc8922ae4ff957aa74cdffd7232ff4d79c6ef5f3a0"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  conflicts_with "mint", because: "both install `mint` binaries"

  skip_clean "bin/mint-sensor"

  def install
    system "go", "generate", "./pkg/appbom"
    ldflags = "-s -w -X github.com/mintoolkit/mint/pkg/version.appVersionTag=#{version}"
    tags = %w[
      remote
      containers_image_openpgp
      containers_image_docker_daemon_stub
      containers_image_fulcio_stub
      containers_image_rekor_stub
    ]
    system "go", "build",
                 *std_go_args(output: bin/"mint", ldflags:, tags:),
                 "./cmd/mint"

    # mint-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build",
                 *std_go_args(output: bin/"mint-sensor", ldflags:, tags:),
                 "./cmd/mint-sensor"
    (bin/"mint-sensor").chmod 0555

    # Create backwards compatible symlinks similar to build script
    # https://github.com/mintoolkit/mint/blob/master/scripts/src.build.sh
    bin.install_symlink "mint" => "docker-slim"
    bin.install_symlink "mint" => "slim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mint --version")
    system "test", "-x", bin/"mint-sensor"

    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine
      RUN apk add --no-cache curl
    DOCKERFILE

    output = shell_output("#{bin}/mint lint #{testpath}/Dockerfile")
    assert_match "Missing .dockerignore", output
    assert_match "Stage from latest tag", output
  end
end
