class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://github.com/HyNetwork/hysteria"
  url "https://github.com/HyNetwork/hysteria.git",
    tag:      "v1.2.2",
    revision: "3d54cb43afab6bb700a35ef77b5436af5587470a"
  license "MIT"
  head "https://github.com/HyNetwork/hysteria.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version} -X main.appDate=#{time.rfc3339} -X main.appCommit=#{Utils.git_short_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  service do
    run [bin/"hysteria", "--config", "#{etc}/hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hysteria --version | cut -d ' ' -f3")
  end
end
