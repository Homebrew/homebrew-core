class Mintoolkit < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/mintoolkit/mint/archive/refs/tags/1.41.7.tar.gz"
  sha256 "a5375339dda7752b8c7a1d29d25cc7e7e52c60b2badb6a3f6d816f7743fde91a"
  license "Apache-2.0"
  head "https://github.com/mintoolkit/mint.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2269c059b101b0cc18a0308f127d4fe78c5ad00b697f3142fd6844fe23d3ee85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3191425ab42a27ac181105eb522ba926cb52c2a6a7034b9cf697e34a41506627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e215a31ad61ca3f81951ca6863d406fd06a376ec10fd2e81f3ae058d6449e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "485651b0b4be33e48ef7907f6239b83585e3028902c266fbab797b4c39bdd46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c396b50f98b248eb69cafd4c800f6ad8ae8b25ed136fbcbeff4ec0ec9bc93c"
    sha256 cellar: :any_skip_relocation, ventura:       "fa2b6fcf6dc740377b6400639d8d1fb00af713fd86f1c7b4027bbe2285f9dcbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc6136219b75f2793bbeeafe5192fb43dda87b68eee59e87c448a7c30fce64ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9d72e0904771231b5c75d6444d6cbdc8d7185abeaa1cafb18257a731e98f8d"
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
