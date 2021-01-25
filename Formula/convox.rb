class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.45.tar.gz"
  sha256 "3647585b31b092aa3c3c7243d3eefb2e83c4593a782a8904dec165f454e24f6a"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "46c750d57369ba9176f837d83674253af263658acf216880e1038b98f4303504" => :big_sur
    sha256 "b5c5484e46e8ba32c0babe936c951fecab00171b55d8dca49ff920b853529960" => :arm64_big_sur
    sha256 "606a7cc3e37e5007e37eae7e6d2f10add0cbf1f272f6158560e01796b1fd2c18" => :catalina
    sha256 "2b0e40402da441ecc00a803aa71c8bac1ee05ef2ca101b4fc9f60cd4e763c847" => :mojave
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
