class Aliddns < Formula
  desc "Aliyun(Alibaba Cloud) ddns for golang"
  homepage "https://github.com/OpenIoTHub/aliddns"
  url "https://github.com/OpenIoTHub/aliddns.git",
      tag:      "v0.0.20",
      revision: "b2fd114d9d9c0cc9e01a1f4d794a5d609a2c350a"
  license "MIT"
  head "https://github.com/OpenIoTHub/aliddns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51af64187981042422c57f4a4e41e977ddf974a3e22eb5b38c7863131979f0ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51af64187981042422c57f4a4e41e977ddf974a3e22eb5b38c7863131979f0ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51af64187981042422c57f4a4e41e977ddf974a3e22eb5b38c7863131979f0ae"
    sha256 cellar: :any_skip_relocation, ventura:        "af66b16954c12eb3e2b94da43422296f7c985824591224dc067cbc09ce4ba1ef"
    sha256 cellar: :any_skip_relocation, monterey:       "af66b16954c12eb3e2b94da43422296f7c985824591224dc067cbc09ce4ba1ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "af66b16954c12eb3e2b94da43422296f7c985824591224dc067cbc09ce4ba1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0792941223e0d472adba98a65cddc7cbd9b62ad3f0eea6417b6c0780810ef6"
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
