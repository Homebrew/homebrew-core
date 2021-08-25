class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.12",
      revision: "adcb7cc3b57c254a43f696bd83122cc693cc7ad0"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0dc04fa8aaf8dd3d48798a71300ddf0f4bb905fe2b97875e9734b7ac15c40218"
    sha256 cellar: :any_skip_relocation, big_sur:       "af588333775b8a9b61968c14ea722882ec52a834550ca6821a4e6ae2ce1f97ad"
    sha256 cellar: :any_skip_relocation, catalina:      "d2d282a93938640e7faa06e7e64c60650ff6f49e7e277a2a479c43254a00d903"
    sha256 cellar: :any_skip_relocation, mojave:        "96a9f4243220aca10644e05801a43069fd9516f0b5f2dc2493c2fe5828f816bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f429badf39c7ff53bbb5f9ab029c90d02fab0d30bf8321ca3d23fb2c75416540"
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
