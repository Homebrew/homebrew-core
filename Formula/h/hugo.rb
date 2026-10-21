class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.168.0.tar.gz"
  sha256 "45ba430ac86cfe8e5fb07b81eaef78769973af9b4d1c51f1d88195e0d438be3e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28d739b37e6a0f8e164a26b8c4f97a11e486a878698e3a93f3710caf9eb29929"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a3e5ea5f9d2bcb3a53de8e653336071bdfce83a98f8249925f61ef906a97cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "045eb666297b94bdaeb10e1b230199fe2e02fa047b127cd569978e26df2fb321"
    sha256 cellar: :any,                 arm64_linux:       "be39811fef5a418dd10df0b36bf75bb213673a5c8a6d0db18276fc0628248ddf"
    sha256 cellar: :any,                 x86_64_linux:      "23ea9272eff90d0538d45eff0f780d0655583e6a7c18c7cd0b21bcd5b8ea6a1b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
