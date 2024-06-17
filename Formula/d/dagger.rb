class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.11.7",
      revision: "8bc62edb288ac68afa76550734e232cb77b74418"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3acb6a8543404d712f21df242d287ce1dd01992bd3378af916c18266e4f61fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2436d2105f9bdc3bf6cb579e66abe34f44539ee849c48666ebce463ab8517097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9a621610446d6dd82150f72f3758b71e46027fa4ea57b78ab238b2d0c689eca"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc5b8de4c361c825b7992fd8db3ecf9da2c362fe3ebc0b104bd4d4ee2be61269"
    sha256 cellar: :any_skip_relocation, ventura:        "fc3d26768241d07a261dbbccde0656f344a3b95428538f737dd21ebb9fecd324"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd278e422c380107320dc65d57fb5d9b4bda705fe9002d44d50d0f262bdcf91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9480ebff947c7fddf9d8b29e8d1dc0a61c8c1ec71662255b2ca5ba5248eafcde"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
