class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.47.tar.gz"
  sha256 "cf09fba7d21a09f4a7441012f509b3ecc634fcb2267b891af9014cdc20cff4e6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "384d9c2da4b3445db66fa4495744bc6e09c11e2add61bec4f91dfbe44c889f9e"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e847f3cb7d868112c6a05569e0566f92d207ee0cfbdf4aedb2ef905a501b072"
    sha256 cellar: :any_skip_relocation, catalina:      "91f718cf481a343bc3df6062c6accede9811e66980a296b0674135e55bb724d1"
    sha256 cellar: :any_skip_relocation, mojave:        "3c5d49aaf101cf984fd0dbbcf88d45acd193a56d22bb2e52d23ad92f6e04255e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
