class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.14",
      revision: "b257133019c0dc01dd3c51170029acefd42d3561"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bc55c3d2e63355e0620190a7cabfc11fade99979e77e3b3f89a577c860644fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc55c3d2e63355e0620190a7cabfc11fade99979e77e3b3f89a577c860644fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bc55c3d2e63355e0620190a7cabfc11fade99979e77e3b3f89a577c860644fd"
    sha256 cellar: :any_skip_relocation, ventura:        "936568263cc3c12b176cd47d0f77ca6c98779f30fbf86eacb2b6ae98fc10a508"
    sha256 cellar: :any_skip_relocation, monterey:       "936568263cc3c12b176cd47d0f77ca6c98779f30fbf86eacb2b6ae98fc10a508"
    sha256 cellar: :any_skip_relocation, big_sur:        "936568263cc3c12b176cd47d0f77ca6c98779f30fbf86eacb2b6ae98fc10a508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59fa48163b605a99f2f11d2236df1faaec683d4bc1e692a31ee536f331e9b4f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
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
