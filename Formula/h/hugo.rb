class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.165.0.tar.gz"
  sha256 "e9c1e7d8e6e09356cc56317fd01b7493d712692390b89b3d33810cfe1305650e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f208a800efd615fe615a6d8925d264909fecb28267ac5cbd21c89cf39fd55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db7e84d12b64abb26230695518a00e7cb9577fc53d3190a266b352876f587977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "370fe497280ffe1c0e92a08c01a4abe4fec561808082c29f6e99d27227250f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "0781f87539899a343da7d6030a29ac08bc6063e843d3ba7dd75bb2773603db9d"
    sha256 cellar: :any,                 arm64_linux:   "e5a257be2eca8ba07bcfd6a260fc2b0445da0b5ab1aa3828caa293748ea7b772"
    sha256 cellar: :any,                 x86_64_linux:  "6abd5139da56ac783f4f25eba12ed12b237ae49fa730ce6f8f3f7a80ac04f335"
  end

  depends_on "go" => :build

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
