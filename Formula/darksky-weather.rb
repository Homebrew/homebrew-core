class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.7.tar.gz"
  sha256 "e5efd17d40d4246998293de6191e39954aee59c5a0f917f319b493a8dc335edb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "af8fc6e9a4a4ed68bd19daabdce01d846f4e8d88028bccca8c9bec090cf53e29" => :big_sur
    sha256 "d21740455ddc5db0a56e33e5f96dd7248d46b680414f5cff834faf3fb670b618" => :arm64_big_sur
    sha256 "736015c107e06e6251e4007ebc838addfe37ad6fa32683c05fb89be3d1b800f6" => :catalina
    sha256 "a38cef91ca53c2d452353cf3a15198b9946b67e7b601627b5e414359d23fa559" => :mojave
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
