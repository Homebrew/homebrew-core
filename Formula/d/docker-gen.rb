class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.12.0.tar.gz"
  sha256 "1a1dfc0921164d9152bb43ae91f371d901018bb09e7f245cb3a9542d6564a386"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "065e684243bf524d4dcaafde755b9bcb56987a996ca7fb0b4504b3459b9dfc92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aef5178deb8b4d8c2e0d1d9a063c17d224c8b6cb5cc9d12e11b5b3e5bef7499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33a97ff38e5523c672ab6b26ac85a1c40cbb072f2cead93a843f1d5340c0944"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b2d4ce537efcb02aacb7f0b5b421347675eff2126e1757ae5e46e2afe83a71a"
    sha256 cellar: :any_skip_relocation, ventura:        "160bd1df5dd646181c1f1a35c2d85d9d191813464855a1937b88f4f5cc77d110"
    sha256 cellar: :any_skip_relocation, monterey:       "7098961dec4bf7daa58e7a3046acfcae268ab28618008e1adaf098246d7e5780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01568ec95481c67213ebdfdd9168108262141030c9679ca17aea0b4410106390"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
