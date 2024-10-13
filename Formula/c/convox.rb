class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.19.1.tar.gz"
  sha256 "030b9c88c02b0407cbc661569cb453f7860411eefaefbc146c5d18d0aefea17c"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2898421fb9d8e96e7d3366c4c2f4bed5e46b38058a571ab1e8d9c6b3faec2c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a45bcbb3596f3d30780605fbd01f9f8cb08e60cc2daf8152d3594d6c1625534"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae65dbf5b5d01a642b175d7e66c67fda75bd3406b5cccee0a2c2439d66440ea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "463577fe20d94ba3c9bbeae0359c667c8449e2054f2cd4cd92ea660c98d3c595"
    sha256 cellar: :any_skip_relocation, ventura:       "b2a63e071a35772ea1d9dc73e26748da53018b68b3617476b2c89788d92d892d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5aba65d66833f88afde276c97acf1c630dfacf310a2aa306f839351d2b1664d"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
