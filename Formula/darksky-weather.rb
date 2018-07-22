class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.5.tar.gz"
  sha256 "89ac1b9e767db0818da8fcf981a27371ebc18b542a47de65713425fed6da53e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "74a814416ebe84e3999e5c465f9d4794402fce9f9f4e8a4552f2a50faf2f10da" => :high_sierra
    sha256 "f4d070ead432f8e052c0e1e77cf2cef24898082ac84bc1a1acbfa8dd71790115" => :sierra
    sha256 "50c07862d0c5a7e7ff4e75963c8af97622f3072b300cdebe4ccb7a9905153d3a" => :el_capitan
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
