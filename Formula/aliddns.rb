class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.9",
      revision: "37e4f959092b0c286019cab29ce36a0e434c6455"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16e5bfb49b749adb380450cde6092020afd9ef4d6ed3fa030c8c6ede11a6bf9d"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb06193d5ebd8d4faa2e358f6d40589653a0a593e7265e21dfc15bfc99816cab"
    sha256 cellar: :any_skip_relocation, catalina:      "5bb2c74ba522eaf8713fb5c04b5e726e0bca16c4cfc406d7b4523187646acfdb"
    sha256 cellar: :any_skip_relocation, mojave:        "a5f4c51abd1deb28e02f1dc97ea2fb4bcde0d297e0da9d6c5a3b4cfb0bf6c135"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args
    pkgetc.install "aliddns.yaml"
  end

  service do
    run [opt_bin/"aliddns", "-c", etc/"aliddns/aliddns.yaml"]
    keep_alive true
    log_path var/"log/aliddns.log"
    error_log_path var/"log/aliddns.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aliddns -v 2>&1")
    assert_match "config created", shell_output("#{bin}/aliddns init --config=aliddns.yml 2>&1")
    assert_predicate testpath/"aliddns.yml", :exist?
  end
end
