class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.4.2.tar.gz"
  sha256 "b3546a867bf4b897cc76c3b8f30d7feeec1a043587f680876993eaaf28b19e02"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8cf9e77072a5b73970320d1f267417aa1411fd4736d3b208bea52ab5b7769a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "947d00714441154797b17f2c2b08fbe4dead02de376911f9a4b39773a46d0843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5a0f03dec90993610f68fedc00617bc40e749e884e780b35d2ff0a5ab43f52"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c24341aa5948f20ac0eaf1e3fcde1bf69daa445ae14565495db9a894a348be9"
    sha256 cellar: :any_skip_relocation, ventura:        "4afb17bfa2f3feef163d13275702bc045dbb92870143dd1822915314bc9d6847"
    sha256 cellar: :any_skip_relocation, monterey:       "68cdaf02b9119ba312c7439968d17c0e09645c9c6a92d7cd80cb1ef6e68704fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b171ab35f31d450c81c0fbdea8fdd144ccc333abfbe9e9a370dc30b5b3bf993e"
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
