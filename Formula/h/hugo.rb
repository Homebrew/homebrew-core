class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.166.0.tar.gz"
  sha256 "599566b8270a0872061f43564d81961a5f1a02857022078d1fcb3a601189f573"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "088bb47ac929c1c3c16826726ad90e886ef11856aea218b8e036df7dcdba4189"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42c0dce318df473c0aeb0b903d5c26e322ddc61775211499b02528418568e33c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "125be6bd5a8c2f380d4d13094a6f3e3adad83aeccc1a93fe394261fa5a49f2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "28dcd3fb14e87d8d723c49e859c05d45200b290d7dd2f827fcdf05898f064d3a"
    sha256 cellar: :any,                 arm64_linux:       "0f25e075da310243e68412e3224e2d1175792993ff8eb359c9f83c68498dc874"
    sha256 cellar: :any,                 x86_64_linux:      "6c7f3d35d92ca89f710228deb52beb4700bc61d471cb77718c564e6f91bbd3e8"
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
