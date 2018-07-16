class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.5.tar.gz"
  sha256 "89ac1b9e767db0818da8fcf981a27371ebc18b542a47de65713425fed6da53e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dfe8972a8944752362a8432caa3ec5d3c519bd06af1d82285c23df68b43bdcc" => :high_sierra
    sha256 "5c680cb4606c5807b5fab4f885f8f995659c449d9c52adf74ccd90f452eb5af9" => :sierra
    sha256 "d8e6d2cd8d298f845f6f706c911f1a1a3c564f441e0a425e12f42d2c9f16e45a" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/genuinetools/weather").install buildpath.children

    cd "src/github.com/genuinetools/weather" do
      project = "github.com/genuinetools/weather"
      ldflags = ["-X #{project}/version.GITCOMMIT=homebrew",
                 "-X #{project}/version.VERSION=v#{version}"]
      system "go", "build", "-o", bin/"weather", "-ldflags", ldflags.join(" ")
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/weather -location london")
    assert_match "London in England", output
  end
end
