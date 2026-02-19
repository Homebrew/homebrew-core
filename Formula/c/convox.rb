class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.23.3.tar.gz"
  sha256 "975ad6932cb0134f9c096114b58632951df7ef018fbdeef8d00e85b73f4fbbdd"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3fe951da5d03bdf5f1514dce65817b717fd4cfb9810682f591cac20b04fa809"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6898911b5a6961b9b98fe54ae0196e9ed42c53b153e9c3fa52cc79ecca7e471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5604668bcc38f9b9481cc1853b8df999e51a6b1dc2238e6af3ee61754fab3fbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f3005e790a517cdb41ddd294701924da22a4dfae557db4942ad653fcb83c9f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d283e7e8886f5ace2872e8c2dca1e25b9785e9adb840c6925c55b9b2ea5bf830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c3632f8722af63454f1b39eadeec94553da0f28db1ed99aaccfd3523ec9b9a9"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
