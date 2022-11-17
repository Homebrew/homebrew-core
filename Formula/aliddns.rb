class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.13",
      revision: "2c2214baf6b016ded184373252cff16bb377d3c0"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850026dd34a736d0fbf82dbb55b6c021672be35170276a23692e117f6fe1a90f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ab8335a2b758f3557053847a848d61dfb53c614abd8e52eadd62352bc45c5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "779eac8f4e88b704f068d542d1c4f209a96edc5ded85e5ecfefa961d798d6620"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b8d305a0925d9e322b260417298ca4210a829391888c388774b521c6a63d6d"
    sha256 cellar: :any_skip_relocation, monterey:       "ad0bfb1477ef8ec7145eca1cbeb4147157c928ebd440a757f054de2d961f2578"
    sha256 cellar: :any_skip_relocation, big_sur:        "107cb79b754c414f6ffc4bf48ad086e502ad1b39aba147177e3490258e840f8b"
    sha256 cellar: :any_skip_relocation, catalina:       "67937c8e5e9379f4eb36adb24f5b1c5330d488dbe032e0cca376709c03f7b29b"
    sha256 cellar: :any_skip_relocation, mojave:         "ee4a2ad57559bd87b208aa6a58d949b2271b99c767c1bc6e6d8a1fb4996f6e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f2e7a4c81fc402a372ea37b80dbf8f6190595122704088744f4ba7c5fc50ce"
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
