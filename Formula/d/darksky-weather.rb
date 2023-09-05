class DarkskyWeather < Formula
  desc "Command-line weather from the darksky.net API"
  homepage "https://github.com/genuinetools/weather"
  url "https://github.com/genuinetools/weather/archive/v0.15.7.tar.gz"
  sha256 "e5efd17d40d4246998293de6191e39954aee59c5a0f917f319b493a8dc335edb"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65acd7270545c3451f69c5fb5e3a6fc819c3f86f7ee6f687769ccdf8ce41a86d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3908f2bff7bb30a6c668211e255cdb4edfb073e90db2d4fd75addc316b061fc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d21740455ddc5db0a56e33e5f96dd7248d46b680414f5cff834faf3fb670b618"
    sha256 cellar: :any_skip_relocation, ventura:        "07f1e787ff616626dcf0e4493d4b7453bf6cf283f8a226899ee67265cd81e4b3"
    sha256 cellar: :any_skip_relocation, monterey:       "2d45683974e5fb879064182bfde515b4d85945e43916fc11763ae1059c59078d"
    sha256 cellar: :any_skip_relocation, big_sur:        "af8fc6e9a4a4ed68bd19daabdce01d846f4e8d88028bccca8c9bec090cf53e29"
    sha256 cellar: :any_skip_relocation, catalina:       "736015c107e06e6251e4007ebc838addfe37ad6fa32683c05fb89be3d1b800f6"
    sha256 cellar: :any_skip_relocation, mojave:         "a38cef91ca53c2d452353cf3a15198b9946b67e7b601627b5e414359d23fa559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f27ed1995e056157202f4785d0d4d28a8181d77cd0a971d6b778aafcbca7abc"
  end

  depends_on "go" => :build

  def install
    project = "github.com/genuinetools/weather"
    ldflags = ["-s -w",
               "-X #{project}/version.GITCOMMIT=#{tap.user.downcase}",
               "-X #{project}/version.VERSION=v#{version}"]
    system "go", "build", *std_go_args(output: bin/"weather", ldflags: ldflags)
  end

  test do
    # A functional test often errors out, so we stick to checking the version.
    assert_match "v#{version}", shell_output("#{bin}/weather version")
  end
end
