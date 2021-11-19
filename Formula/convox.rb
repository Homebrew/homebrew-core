class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.1.1.tar.gz"
  sha256 "5ae41f8c6503dbaf47593d975369f289319e7d0177f34ca91e83aa045d60b03f"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf28145de907e712c3ed10bd72356a735ad248af86848e67f87927778358517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de24aa2e37a72d69ee31bf186f3e26dc06bfd655dd88f174c48bcaebeac9d5c7"
    sha256 cellar: :any_skip_relocation, monterey:       "48b0c495af77d6b87f2ace66d5e54c4b864bef65a11e9c347fd766c7d1b7f92f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3ed72f6fdbf628e518b0c17c2cc74864e9407bce0ab8822d2464025dfef35ef"
    sha256 cellar: :any_skip_relocation, catalina:       "c3840d0b68a16ec12b4bc6895cb56ae7eba07f5d00a34e009d88a1ef01863f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02bb254412b9c9658274167df25c0637a4e3e0803d35a4a568d76945f9050d1f"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
