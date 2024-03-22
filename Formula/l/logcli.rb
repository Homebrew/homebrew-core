class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.5.tar.gz"
  sha256 "811ac5ba12f33fad942a6e16352c12159031310fd8a5904b422e90e09ac2e94a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6b263def59de49b458227c11e4f94131c2d0128b08ac895af4e15938c6df936"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c1a341eccb6d6cc56fae216c0eedbc8b2fe66711e70f2bed0612618d5d84fea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf96f98ba3ef58ea5dae2796b48c65904b0d7095951cd63e622cb9ffb36e6c0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "720fb924a07d22418a71878652bed1a10cc538ea6ceae1a6feedc7a1db19b93c"
    sha256 cellar: :any_skip_relocation, ventura:        "512df8660ababcadebeda89f2f8c96bdcce5df7e11dfd7c4c88b4e4c4b525dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "9f0f38a740ee46cfa7921a5923bcb5346a523426b8bdc05beee2a40284fae061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcbed2454dcb028e44729832ea96efee84e3e47f3cc904fec26b21ee5d450d35"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=homebrew
      -X github.com/grafana/loki/pkg/util/build.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
