class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/jessfraz/weather"
  url "https://github.com/jessfraz/weather/archive/v0.13.0.tar.gz"
  sha256 "ec4fbb17f4a1eed0e7254190018ce5226db1250e2a31350ce19fc7fe11451412"

  bottle do
    cellar :any_skip_relocation
    sha256 "0eee8bcc77fb6d58c09fd4665fd83ce162f3ab6c463bd314df88126b60783788" => :high_sierra
    sha256 "ee3d3dab793717870072153b0eeed87d17f9c824110f2981e538b8383d0ea97e" => :sierra
    sha256 "3171ab422accd6d65c7d67cb5c678c11defb2d48fa8d7dcf5f624e6585a2fc11" => :el_capitan
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
