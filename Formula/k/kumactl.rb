class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.4.0.tar.gz"
  sha256 "dcc6c225667f4535cde7516de11bc4908300c746bd4ea23a44c10a7807df380a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7f03fc5982d270c788a07da8858cdbfbf68abc988cfd05898710f0876dab726"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f24ba3b13a172e817c12255f5db976cf44d3a07151d1044510170789250d94d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6b6482656dd65f70fe4d24f081e4493e8bd6393b52319b2fbae6184b073b195"
    sha256 cellar: :any_skip_relocation, ventura:        "7c5efb864ff9662db8345998b3e96a59c7c679bbee71a82810af126ea0446e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "afc4402cbaf7b44077bf65e3872d09f6b0895ad0f4345e7f4a6041236e36704e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3be1606abc00366179505637ce0cdc1002773edfcf1e021259a8a30bed108960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e0ab1fefe2fae93a9a3dea2e0283ed2c56835bc8833c389097f1d6d43826d95"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")

    ENV["DESTDIR"] = buildpath
    ENV["FORMAT"] = "man"
    system "go", "run", "tools/docs/generate.go"
    man1.install Dir["kumactl/*.1"]
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
