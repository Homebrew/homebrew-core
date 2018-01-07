class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/jessfraz/weather"
  url "https://github.com/jessfraz/weather/archive/v0.12.0.tar.gz"
  sha256 "f98ad64a23a40e9e6305a93ea8824b99e0dd2d85effb91e102e9b26285adfa9e"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jessfraz/weather").install buildpath.children

    cd "src/github.com/jessfraz/weather" do
      project = "github.com/jessfraz/weather"
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
