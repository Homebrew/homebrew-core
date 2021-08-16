class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.19.0.tar.gz"
  sha256 "72da68e7aa94af954eb683c81bbc6031c4b173764f4c087ed4230909c545501d"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7478a9b3302c04c4a92e51366a9aab17a3787d4e041bd112bddcd97951b85f64"
    sha256 cellar: :any_skip_relocation, big_sur:       "ff64877247d4a86df9add71a04f948447c964c5387bf25b07b94bb4b8b535b33"
    sha256 cellar: :any_skip_relocation, catalina:      "64c6c2188b76d0d39fe8bd536b2bb43ea52677b17a3a265e4800aba9679837ab"
    sha256 cellar: :any_skip_relocation, mojave:        "ef13e65365cbd8d4cfb7ac699faef9ecc75fc6491b2be127f903f62867c7daa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8454da98513b2f184245f4adfbc577c287deef857c1d8c8636d5d1ce19aac50"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
