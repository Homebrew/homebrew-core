class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.5.2.tar.gz"
  sha256 "e15e53c00e47fda93ce551fa71657ba79f22fedb64241694ff42cb53796bcec9"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34048267199aa1f8df01b32acd4cb5b55d92e081673ca6daff040aad0d7cfc78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3deee342b03bb60b1dc4ba6b89e1d1b395f009e31d7f95288dab9c74cedac1d8"
    sha256 cellar: :any_skip_relocation, monterey:       "06225e2f2eccacf2327f0c54e4aa0f6b6ec53c5d638515d15fc205ba81217df5"
    sha256 cellar: :any_skip_relocation, big_sur:        "06ffa4cd12570a49379fc685afd153138df27d36ecab32423398d4e1846e59c1"
    sha256 cellar: :any_skip_relocation, catalina:       "18c1fa2b6b7e29751a86cda1a17212c7f63e3333ed1ee936d8f305bf7b7ec0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb8ed51ffcee91e14829ac7f2da8a18d88855a711d1a21e68ec2570d747dcfd"
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
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
