class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.22.1.tar.gz"
  sha256 "8bd267c9a64d9e0a208a20ddc5a918630a4347b8bcdcf4a8d35f7b77b303393f"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "526e14755970980a7455d2c1a20ed909bd6ef5e08ba831828fe6e28321927ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe542a709a5a345416f1462fc375d9063f1cd1a154c826d1f4617b63d5da5db1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "061c9385a209ea92e7c84b0bd3ea706129e40582f5f123a50b2fedce2101f556"
    sha256 cellar: :any_skip_relocation, monterey:       "7f13fccf3510bd4fb0a9875f9d3129a9c6ec3a6801f9e97336961d42ea39be75"
    sha256 cellar: :any_skip_relocation, big_sur:        "8099935b85a38267a6c046fa2e7bd721b9660127560fc9124bceed53b8230a77"
    sha256 cellar: :any_skip_relocation, catalina:       "a1cd2857fe90a651455739fdb475da4b91daff3e0a2b613fba52d9cf57afa2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2883ee7da95232c222093518407e6a3891bcbbeb04eff47a83c78c44c0fb881"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end
