class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.50.tar.gz"
  sha256 "e6bd27bd4e40617c69fa4a888408ac12bb00e49679ff16afd4561407ade87e51"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8345f71b5f8d27e990a92e8f60bf57b96f38dca5e90a2dd230e7677e1c3a640"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6ba3b89abf2ae07853e3ccd70cb99f8542136f8faf4413668b38a0abc66562c"
    sha256 cellar: :any_skip_relocation, catalina:      "43909c72c5316de316298a865725e1e437c34b550c9934d148d293ff227290e9"
    sha256 cellar: :any_skip_relocation, mojave:        "894f4a5c518dee623d9d8b64236925937355f8300c98185d35acd71d35b3d967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27eaf2309fd6f795a2a10c910308fbfc7a2962140fe7d8589ea26e272c9ce936"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
