class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.19",
      revision: "3d56b2bce4ae93bc569990ad650bb3ee5102564e"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d080c109d24d79605f27eb16be2e80a2de83e10d5c958f17dccc58fcc3f51a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cd951d9bb23f7ef43edfb57d9f9bc76663697ab93640148f0ec05aa99af489d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd951d9bb23f7ef43edfb57d9f9bc76663697ab93640148f0ec05aa99af489d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cd951d9bb23f7ef43edfb57d9f9bc76663697ab93640148f0ec05aa99af489d"
    sha256 cellar: :any_skip_relocation, sonoma:        "93e69edf70c991060b61100822a072f4bec0236254800d82651eb05d812865be"
    sha256 cellar: :any_skip_relocation, ventura:       "93e69edf70c991060b61100822a072f4bec0236254800d82651eb05d812865be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b45f3dcf1ded648b174af3f3d7bcd5b98f272bb8d22e56d3539cfe13b9aca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a792bc4b0b20944b8fa24491d177d2eaf963e17b694fc04451e5389730a09ef7"
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
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
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
    assert_path_exists testpath/"server.yml"
  end
end
