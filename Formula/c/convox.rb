class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.13.7.tar.gz"
  sha256 "986ab8ba8507b4d381afd96b55b07937842a9d3905793c41b633047c05a6ba68"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4caa4ec44d0dd4b4c81d65f8ca0247970e99ef1047d0dabe5f6079248327e84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f48b2d3ddb1fbd842570101a1a7df20c6561f8399298b971c67d2a539accb01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5d223775d37befeeffaef26a17b85458b8028b832acfbeb5aa7ad6c4d99414f"
    sha256 cellar: :any_skip_relocation, ventura:        "d67033fa0dac50dc3eaa2e141024f7ac21c8a2f196071b03202ad8847ccfdd22"
    sha256 cellar: :any_skip_relocation, monterey:       "35658778702ef51934ba14c0b6fb71f64c0ea246458c37972bb52d21deb36387"
    sha256 cellar: :any_skip_relocation, big_sur:        "e05588ec1d6643ef63130f1efbb4a300f431cd4d04ad606186d53ede3b624fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbd236ca08fccf24bbcde0e1c38919be100ae6cbca2e5a3fd696b4b5203cf398"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
