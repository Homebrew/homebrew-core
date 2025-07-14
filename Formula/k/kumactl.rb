class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.11.2.tar.gz"
  sha256 "ae4ab2767485c53d51f22fb43f7edbefaaba99bff796a5f00be651a04f444654"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f195aeffbcd3008dce92f7ed2273c74326ba79d2e8d5b1f99e6a533bce993548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2b37f89c5e76d27dc217a9921d869ea51290f6c97746bc73e3d3e9bc23cf25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ff86030b4f62ea46ef3699fbca7f3d592322e985acfb32f1d1fcb0a7c38bd8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "108548058ce3624097abec54d0944b1c61a9cfb97116acf765a5b75f3dd5430b"
    sha256 cellar: :any_skip_relocation, ventura:       "b219d0082112820934489c1a361b3806d5ebcbb766323e827c7a9d067459ad0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e6bb5750d76b4ef3471c3b187589e6051868a9a5073e39fcd6b559fdd7d8458"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
