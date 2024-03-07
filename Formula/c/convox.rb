class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.16.0.tar.gz"
  sha256 "c2ba3292d89b0c8ebf5dca0caafc753f7e5ff8eb404fc0e1032bd189c58b4208"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4df860786988bc77241f639ec6729a618e25c31e47191f8449671941fc47f65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df678cd596af9b5d74b97e6e872c0c067c0fb010fc4d7fbb193ac71b6830a1b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7b6fdab20136a2e6d97b5a49adb87bb2b7fcfefaa9c781e64a24a25eb9c5b54"
    sha256 cellar: :any_skip_relocation, sonoma:         "1253b85177edf671c74a372d28b815bd46e411eca11bfad3e75cec9468308fd5"
    sha256 cellar: :any_skip_relocation, ventura:        "fafa648f7237c0d7381930fb1c12ce22add9d63d8130c0f62a06a239ae91d812"
    sha256 cellar: :any_skip_relocation, monterey:       "cd04e2ae410f0b4bc1efe7088ca88d0a4288ddf9f5a3a1b302baaf8f16062555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ae18964607e351c1a3644f81ad9d7c2822f1cf4cb310158038501f6ed0d7bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
