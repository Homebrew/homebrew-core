class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.7.tar.gz"
  sha256 "e5efd17d40d4246998293de6191e39954aee59c5a0f917f319b493a8dc335edb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed2ee9baca087ab4fd02ee792514135a7a2d1d685e3fa565567918c1d85a94aa" => :big_sur
    sha256 "0c2e90c594b2f9d0384e350b4fa6d1dc0997f0e79044b60321911aa5d4d6c3ce" => :arm64_big_sur
    sha256 "64aac1bb9c9f6fc856fdb6e818b11d715addb17c6f35480abf0a337c1dcaa311" => :catalina
    sha256 "ae72f00275774f08c66fb8f90697545b97701c4fb819416fb6215779ec775cab" => :mojave
    sha256 "b621c14d94f6e0e1c350e0bc78c0269bed889b065d811acb8da39d137de5ac4f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    project = "github.com/genuinetools/weather"
    ldflags = ["-s -w",
               "-X #{project}/version.GITCOMMIT=homebrew",
               "-X #{project}/version.VERSION=v#{version}"]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
    mv bin/"darksky-weather", bin/"weather"
  end

  test do
    output = shell_output("#{bin}/weather")
    assert_match "Current weather is", output
  end
end
