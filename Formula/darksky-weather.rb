class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.4.tar.gz"
  sha256 "9907f0025d36232f0b1e37633d14940510890e19162cb840d3fb39e930cc75e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "4715a19399501e6418096418cae5c6798de81f397333fde968828604fb48d281" => :high_sierra
    sha256 "d17d8161f0e29ec3431dd72740352483ee0d80c7b168e9e8b58382ea69687923" => :sierra
    sha256 "cad678d22987a1143a9633d219c103de85b5ab84110bcb2fc1f21e57f8f4a9c3" => :el_capitan
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
