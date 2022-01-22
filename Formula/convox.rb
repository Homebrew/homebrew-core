class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.2.4.tar.gz"
  sha256 "7352efbc9e490e5433d304712b25756327cadb888653e82f58d28e73dc96aec9"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51963f7b2a9d1b737d6b5d6cdab3c0ecb58af9604a88f942d9e56c050a9731f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b9446ad1a80457d90ca4089c156bcc3916562fb7e5d89868063101cce691d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "1f72635447deff43e8157ea4afeb0747ba9de989bbc6b2cdd9ac2fbfc2bb8a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "52fabb38bf63d4d5d7a2b958cd7f116d540c79651e318074b3fe46a2c80c09ad"
    sha256 cellar: :any_skip_relocation, catalina:       "47721bdc9832f9ad382829173cf71a33bd572febe2391ca3d4fe6005d2c6ccce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f380f08cf12bca7b9acef7a01a99d59aa4b633d2d33d19ea5aec0ae3c92c9a52"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
