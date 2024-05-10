class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "e5fb1028003745ffc185b6368430904417f2f4115ad6524233c11dc0bda99f10"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99ea86dee9c68337457ac58ddbc5ec07698d5f1a845520fadfb0af71cf81fcd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9383e428a8a8804ef450ba840e5264ddca4595b442a77693660f5300265a2f16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37312592a1b19caf99f43ca587b14165cec49d6a518c1b8e0b625414c0ec803"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f0b1479ad988219359327b4cbed6878a35943a0814c0a05a06fe0565b9689b8"
    sha256 cellar: :any_skip_relocation, ventura:        "295af410d0a2e926fd05bcc03d512592aa3fc10b66e1de7e9517ae6aa7ab3a0a"
    sha256 cellar: :any_skip_relocation, monterey:       "09bd9812ae395143ba3824586437da6a05e8b0934003060cd56f243e75d08e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722197a67a6c6f43a608f07725f5dcf3b07e8229539bc23d793f1e15127b4591"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"
  end

  def post_install
    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec "#{bin}/autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
