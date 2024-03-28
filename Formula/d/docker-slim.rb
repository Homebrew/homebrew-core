class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.11.tar.gz"
  sha256 "82652e5ff331f64083b98e1c24cfe4210103df469fc22fd89635a37f6580d9d4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "855bfe260abb098215f7c1e776e37b00ae1e63f9e633c67675632d94bc1be5e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c40b91f83138ae4309ca53a6b400847f3a1d27918711861e2b77d2f3bdf95fd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a6f07c033f409f6ec63e16b0094a7b9d4d8565d8a76857f190434db9fa00b11"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b4aabd09784a08f074d2d2957142b6e9cb85d7197b3705d74bd30d9c9f01952"
    sha256 cellar: :any_skip_relocation, ventura:        "3fa3ca92496b509abb16b694d85a85f4c57e9b6c924529f68b43019605310aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "0e8b4817f06c7777232ce31e349e9f6b8dbc7532cd6977e0f87a8b97816d07fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d65a744e5c8e376327fa9db30894b0bbc99b2a21603b91a938f0ac2eace45217"
  end

  depends_on "go" => :build

  skip_clean "bin/slim-sensor"

  def install
    system "go", "generate", "./pkg/appbom"
    ldflags = "-s -w -X github.com/slimtoolkit/slim/pkg/version.appVersionTag=#{version}"
    system "go", "build",
                 *std_go_args(output: bin/"slim", ldflags:),
                 "./cmd/slim"

    # slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build",
                 *std_go_args(output: bin/"slim-sensor", ldflags:),
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
    assert_match "Missing .dockerignore", output
    assert_match "Stage from latest tag", output
  end
end
