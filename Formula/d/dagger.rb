class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.9.11",
      revision: "77a53a85956942540fb2078ef490ac8eeac56e0e"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dacd7f290302d8043b4592661d7a983d402d89f61ee6ca48af79e0acc0385924"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cec1720600cc25ce04fac25264035a9e9ecb032b1748f219d4ea27034227f4ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5750e0193985c120e8ac1492ef4dbdb9ffcc2474c742821ce25121dc1103af62"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c7d8ce2b503719b859286727a1fc6c31a2a7e794e2785ee58d207e312f96c1a"
    sha256 cellar: :any_skip_relocation, ventura:        "444f3e6a95dd998b2e10e00a099de135664241c1d8fd03727d82796a7fea5d7c"
    sha256 cellar: :any_skip_relocation, monterey:       "66eca09c7911ed8362ff66670201a2a3ae82e2d001d3f09ac064496719e5e724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e04835da1c0daebb37360ed80080e454eb90ea7ac6283907778ed2d6be056c"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
