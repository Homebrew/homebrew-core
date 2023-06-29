class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.16",
      revision: "65977325792d44b0592fe1b2f193eb4d9b9fa0df"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46048e2d888d15881ba175ac002b517eadc693567702e1912cfc975b275e0da0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46048e2d888d15881ba175ac002b517eadc693567702e1912cfc975b275e0da0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46048e2d888d15881ba175ac002b517eadc693567702e1912cfc975b275e0da0"
    sha256 cellar: :any_skip_relocation, ventura:        "f3e93a15f35c921db3613eccb1488f6695185aa9111f992dcc2e300c6ec5f297"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e93a15f35c921db3613eccb1488f6695185aa9111f992dcc2e300c6ec5f297"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e93a15f35c921db3613eccb1488f6695185aa9111f992dcc2e300c6ec5f297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aa537f9e94e54399ed2e8c1bd8e7e442523d2ffa435339f374249b01fe77b5a"
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
