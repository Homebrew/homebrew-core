class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/jessfraz/weather"
  url "https://github.com/jessfraz/weather/archive/v0.13.0.tar.gz"
  sha256 "ec4fbb17f4a1eed0e7254190018ce5226db1250e2a31350ce19fc7fe11451412"

  bottle do
    cellar :any_skip_relocation
    sha256 "a36aa65cfc31428bb373d607314259930ff86c4110307ab29b7912809c710091" => :high_sierra
    sha256 "be28f9457ca527cb2e1bf92d00c0aad7297c0319d9e4a67a9270bbc3f845809e" => :sierra
    sha256 "34f4367d8b866424d6ce86368a9e4c72dc7fcd3f6fdf5c0fd76dd234260c2437" => :el_capitan
  end

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
