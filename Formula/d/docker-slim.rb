class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.3.tar.gz"
  sha256 "7b72b423ba3d031cbd5113ad35bf2ef1e8f2088f7dbb37e348ca5cd8292af1bc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc051ed5957049cbaa5217083e95ba24e3944c5093e9cb7af0626a8c62124953"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10292c47f2690b7c41bdafb01175c48597735c405aa72bc96a6052e1b440ca89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc5475200fd870b5d1a91899d2fe998b56e2b6fb8261cf44a46258d6234449b0"
    sha256 cellar: :any_skip_relocation, ventura:        "e7bf1e53a1e573e774ac53657ab6cf157f3a85c0abe61806d493b6a800b19465"
    sha256 cellar: :any_skip_relocation, monterey:       "b288fc055b442a0ada12e85223913e3bcba7c9f7ec3c2bc8c3ce1644dab5137a"
    sha256 cellar: :any_skip_relocation, big_sur:        "951fdac1fa02e5808e5ff7f458856d9158ee0de4f143a2c5a7937a5ec72249cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a62303baca3dcada61f20014382c4b3b7bfda211d54b640afcad17fd68021eb2"
  end

  depends_on "go" => :build

  skip_clean "bin/slim-sensor"

  def install
    system "go", "generate", "./pkg/appbom"
    ldflags = "-s -w -X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=#{version}"
    system "go", "build",
                 *std_go_args(output: bin/"slim", ldflags: ldflags),
                 "./cmd/slim"

    # slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build",
                 *std_go_args(output: bin/"slim-sensor", ldflags: ldflags),
                 "./cmd/slim-sensor"
    (bin/"slim-sensor").chmod 0555
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slim --version")
    system "test", "-x", bin/"slim-sensor"

    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      RUN apk add --no-cache curl
    EOS

    output = shell_output("#{bin}/slim lint #{testpath}/Dockerfile")
    assert_match "id='ID.10001' name='Missing .dockerignore'", output
    assert_match "id='ID.20006' name='Stage from latest tag'", output
  end
end
