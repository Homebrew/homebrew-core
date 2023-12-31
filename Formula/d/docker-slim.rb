class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.7.tar.gz"
  sha256 "b3cbfb6a3bb36bbf1a4d2807756a759d5a9c27fe25efa576c32d6e4e0592b449"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "902680fe563bda2a930d8a1e7092a3a6bf9eb0234160d305ec2bdc0ce01be771"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eac110aa0412c06dd01b4d445b61d561c550c9378a38e776d80e3166a1af97df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c76126b3cb7dcfca482c0a7ec8f21653b708dde4454270fffe7a377f30150beb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9266c13dd62a688bf28444e96061fc975486bdda28c2901247c0d7bf988442b"
    sha256 cellar: :any_skip_relocation, ventura:        "0c290232f74efa1fd12f66fa9a7a09fae76b0bedbbf8d0716e06f0c66cf9fe3d"
    sha256 cellar: :any_skip_relocation, monterey:       "5f2a536496bd310ccbba6731d55761964dcf18e8cc60b98cd4cf25e6af5561d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ec021b811ffe404a5b678de5079252c960b19b13e96e95d4b97158e5c0cd1d"
  end

  depends_on "go" => :build

  skip_clean "bin/slim-sensor"

  def install
    system "go", "generate", "./pkg/appbom"
    ldflags = "-s -w -X github.com/slimtoolkit/slim/pkg/version.appVersionTag=#{version}"
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
    assert_match "Missing .dockerignore", output
    assert_match "Stage from latest tag", output
  end
end
