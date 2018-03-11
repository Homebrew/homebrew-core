class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.0.tar.gz"
  sha256 "3320fd482dbda0a24c444216566c840bb9ec98e353287db427608d111ccf46e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "46e049d61c74e6c48628891f673ce423c3804aab701970a2a57e1c9388215b07" => :high_sierra
    sha256 "540bed62bdf4b2d62492aa1599d18d5ce11d19114c8101fe994b713bd75a0854" => :sierra
    sha256 "84edfbcabc9a4feb3e433cdbef16fd64cb800b9f7cb95cbb77a59018aafb9a82" => :el_capitan
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
