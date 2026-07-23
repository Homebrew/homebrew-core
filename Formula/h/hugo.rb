class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.164.0.tar.gz"
  sha256 "4d32803c88e76179bc48cf640821977dd1cd83a8aa64ee17766557a15e538825"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "183994da58d25fa5c2345f0cfabe5192e435249e868aef1e28092f45b8c7b5d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e1d6e83a37e1d4c3b353763c927b873c04145cba15143a8f8d2e64dc746bbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc4775a0873f3ae861a193c931f3de6e687133ebfeda981cf24ec499857cef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d28a7032cd3569718f33dfd7995d2ef50dc7fb66e7fd035a044e4ea37e7b46a4"
    sha256 cellar: :any,                 arm64_linux:   "71735a97ec2e7208db2e4d1d1af39af06a529a62d971df3a43387af1ff5523f1"
    sha256 cellar: :any,                 x86_64_linux:  "2c35ec21223913f72601817a975868fc1d69a9a799002ade742bffe28040a327"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
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
