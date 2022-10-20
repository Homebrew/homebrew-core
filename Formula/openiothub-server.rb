class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.1",
      revision: "e9b10913f1e291cebd9daeeecb88054a51585759"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13dbc955f87f4db7312684958f4a37e10a87fddbc839b28d727f6a54754475de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "611a932dba202a72cda774c99e7e4fcc946dd9ea3ed5905dc0c9458a0a3c16e4"
    sha256 cellar: :any_skip_relocation, monterey:       "68189ff6031ff8e611d6a1a858cc485f0410f0ba5a35a5492beacfcae0ecd798"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2d3403311ba16b4564ea082a2eabe71a2dee04ee67a1de95bc1392361793072"
    sha256 cellar: :any_skip_relocation, catalina:       "d5a7c18d1ebb71d72a9f8510e19be548b529f26af377762d394a6fcc556e6ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e79346dfe3caf01f3e10f48de9f284b642146665b0d1c49916cfd55fa8930e0d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_predicate testpath/"server.yml", :exist?
  end
end
