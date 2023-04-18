class Gebug < Formula
  desc "Debug Dockerized Go applications better"
  homepage "https://github.com/moshebe/gebug"
  url "https://github.com/moshebe/gebug/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "1fc4ca057db026b23e62d8db67107ebfe648b68d7ec656abd10b2bfd684f29a2"
  license "Apache-2.0"
  head "https://github.com/moshebe/gebug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "756ecb4926bf082047e379c5abc2aa267073617ba66ea26a6c0f99725de7a25b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f5b02c9bd0e0b24f17b152bc4a714346844f22f17759287008576ad240c7b27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f526c66051c98b69817247e6ec0ac180f11bd3658b77595d2cc8ba7d3f678826"
    sha256 cellar: :any_skip_relocation, ventura:        "1f8f621d73b01d68776df1591ec04672123527b3a396920e077f4370c021f17a"
    sha256 cellar: :any_skip_relocation, monterey:       "574f20b58ccab0297e79eb61752f32255a6131ab282c3d17dea3573ebc0e2aff"
    sha256 cellar: :any_skip_relocation, big_sur:        "e03bddf6ae9d8bd4402d46e5b8890f28dec307907c422e122a98553e45bd3c5e"
    sha256 cellar: :any_skip_relocation, catalina:       "9c92e41d093d543a447df5dbbe3a1de30894002da48323c4277dbf94bfefd114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba3d9508a2bc58a6afcf69ec0679fd4635d438b8b8e6324ccc1500b9aeabe0d8"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/moshebe/gebug/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gebug", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    (testpath/".gebug/docker-compose.yml").write("")
    (testpath/".gebug/Dockerfile").write("")

    assert_match "Failed to perform clean up", shell_output(bin/"gebug clean 2>&1", 1)
    assert_match version.to_s, shell_output(bin/"gebug version")
  end
end
