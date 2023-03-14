class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.5.0",
      revision: "c2df5bd1f0d88315d38f601df47e63be6f136d2b"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "118bfc6caefe9b114bd38fc83bd53f0c9038a1e33a19f8abde4da9d1372ce85d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "795d0d3519fadf191d29835ae0a87a9d47548b0fd2d05afc60efc2f16dc43c9a"
    sha256 cellar: :any_skip_relocation, ventura:        "f113fe2e7f3294656902251a8e74df9ce0aa2852d7fb3e0cbb9b13f932fd8965"
    sha256 cellar: :any_skip_relocation, monterey:       "b93baba164b6646d711f03480adde4ee66ced458d6595ede1001254c15bbbccf"
    sha256 cellar: :any_skip_relocation, big_sur:        "da98edd3a7b925edad899700bde563f6b13d3342869475183ab672f559d9fdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515b9b9af57b1d0b453fff420e56ff36c46b8365c0b6bcc5d790933f230274f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
