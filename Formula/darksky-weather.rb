class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.6.tar.gz"
  sha256 "a10edddd0e1157dbb95b3c31170806d3789f00939e4192ad90bb23a87a70e48c"

  bottle do
    cellar :any_skip_relocation
    sha256 "65017d8799925fab8fe8533fb385fb56dc6a22114ec0092f624031c926e550e1" => :mojave
    sha256 "2b385bbbc7310dc75466acc8bba635ffceb523788f66040933a201f476d0b9a0" => :high_sierra
    sha256 "5ba56cd686eb287578ddfc1ae25d5896ffd699b902852b1d68a0caaac4148f6e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
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
