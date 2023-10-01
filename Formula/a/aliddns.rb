class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.21",
      revision: "a447f1ef43f22c2eb2fddd59486ed0ef8257c26e"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c1fa2a07776d26dafa155430ec3a5bbb8b15d1226813a23ceb324da02505f70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff644cca8f603741b2cac0270532760e3aaf43020cb127a5286f9ce11e40947d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f71ddb20f2bd87060176f29840ca105e33b7d5bc903c9fc9bb19d57d384c47"
    sha256 cellar: :any_skip_relocation, sonoma:         "0353c94a70f7e5c45b9d71b12c833d44cd857243a317eb0a21b39cc0cd660d35"
    sha256 cellar: :any_skip_relocation, ventura:        "c97544de0b6440bb45194b1adf7ac134e10749c0b9100b49ffeb65484c505955"
    sha256 cellar: :any_skip_relocation, monterey:       "68092f8e491659a60f21aaaec4531b72e21e80456750c5fff92020bb3053b074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733e0842cafc07964c54b1cd32f1c1dde98c537fd4272bf5003a05d72969884b"
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
