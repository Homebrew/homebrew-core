class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.2.5.tar.gz"
  sha256 "f55f55c09671b4d72fa7c336d072514a3dbc080a7c54a46003cdf2c8d25b3cd2"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2168f7203691eedf62ea8b2d2db4a691d42b1f05896dd0f7404983d7c53b15bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a19a9d73a354db1618a8aa0f65eb18b0e28ca3a7efa953c3f576ecc2c6072456"
    sha256 cellar: :any_skip_relocation, monterey:       "1cc6c3ccaa82cfca8eb055bb1ca145d3de35f79d8a1f9bca9df7dc8782f8913a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f090409df77633cf34839c2f1ff6f0912a66781860a7638ff0d6d986869d1b16"
    sha256 cellar: :any_skip_relocation, catalina:       "3af33039039db783a39b3ca80fdbdd47ee03d502cade43ed8f9e5c6d2cd2ab37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "522b5aecc940f674e2700eacfc603dc283103123f6060386763ba6c88329c58d"
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
