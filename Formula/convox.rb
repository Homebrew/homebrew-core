class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.46.tar.gz"
  sha256 "19160e0693a48e8f3a5641ea0ce03208f0027f9b453d0162ba79a22b63c40afb"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5c5484e46e8ba32c0babe936c951fecab00171b55d8dca49ff920b853529960"
    sha256 cellar: :any_skip_relocation, big_sur:       "46c750d57369ba9176f837d83674253af263658acf216880e1038b98f4303504"
    sha256 cellar: :any_skip_relocation, catalina:      "606a7cc3e37e5007e37eae7e6d2f10add0cbf1f272f6158560e01796b1fd2c18"
    sha256 cellar: :any_skip_relocation, mojave:        "2b0e40402da441ecc00a803aa71c8bac1ee05ef2ca101b4fc9f60cd4e763c847"
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
