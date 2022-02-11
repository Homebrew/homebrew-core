class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.25.1",
      revision: "b2acdc17baa7bbb2f9925b1c5618d00ae3e2d789"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bf3caf0c34cbf5e35802cbe75b9d92daf4779187e23cd9d828c22054f71f38c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8648d9849a85d0b6665dc77413a9b321413e4574ff2e4186f45504d72bd0d548"
    sha256 cellar: :any_skip_relocation, monterey:       "aa00a289caa580e8ae9f4f37745760bbea3c19db3f143ff12de3a9dd94191336"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dfe0deb8160cd0c989fcf8744c0577acdb81cdf39b7193d3ae4e04fc20212a3"
    sha256 cellar: :any_skip_relocation, catalina:       "d3d27512afd65a6fee622c669ce6f2ee8a88b5ce64bb1f8bca63154527903ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24dcea49b3aaa0cc0c58b3afd33f7c427db54611c8e88d0056a10f65f96d41a5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
