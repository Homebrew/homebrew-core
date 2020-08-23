class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.7.tar.gz"
  sha256 "e5efd17d40d4246998293de6191e39954aee59c5a0f917f319b493a8dc335edb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "64aac1bb9c9f6fc856fdb6e818b11d715addb17c6f35480abf0a337c1dcaa311" => :catalina
    sha256 "ae72f00275774f08c66fb8f90697545b97701c4fb819416fb6215779ec775cab" => :mojave
    sha256 "b621c14d94f6e0e1c350e0bc78c0269bed889b065d811acb8da39d137de5ac4f" => :high_sierra
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
    output = shell_output("#{bin}/weather")
    assert_match "Current weather is", output
  end
end
