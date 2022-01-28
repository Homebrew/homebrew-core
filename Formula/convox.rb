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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14fd95ccbe360406eabf064f587cc191212559f66c8f26d3e072074954207251"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "353f8aff85f23b2972cefab139edc17e24286743d46d18d3b76d5b36af2b9d90"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f6f79f3f234e36d2696e23ee3fb51c219f1733fab025bcc676eb5f390244e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b80b5268e30d2a2d2d52085a554cfa27b6857a348d0e77e2398a7102d80ee958"
    sha256 cellar: :any_skip_relocation, catalina:       "15be5001ad09836254ae3dee0d9286ecfc2fae609dae81ed8094a8a3c35f15ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a1ab755f2f8e794f302acb421b5979212369337375b0f36de6b0659f6a4ae4"
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
