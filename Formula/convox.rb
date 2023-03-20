class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.7.tar.gz"
  sha256 "ff634377e480affdde9c603b696ce103ca59ec0c3dfe604e54ac37301a60b250"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cdec0a8890370faaa63ebc02bdf536b578af0f5318d91124671a1227755df89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fd4d3ea9220021846c428491f66d565078faf47c702f286d9db05def229f1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b1a8bd42c2afe1ae0faba78746317934abcba4f4d097de71613e40432860f19"
    sha256 cellar: :any_skip_relocation, ventura:        "68d75d7c558099af26d3ec48b361a37eb0d83ae675cb9928c464f270fd6f753f"
    sha256 cellar: :any_skip_relocation, monterey:       "438e5fa9a19a425316e2509dd19b406484d88e4ddf9caefd671f58e94c3182c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d76972065c8f2219d095eca9cfcc84e31f90c51e1dc0ca83159a79aab23c85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea902128de795fe68d53c80b0d148283caa13498cb4773ffe79be3625ae3563f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
