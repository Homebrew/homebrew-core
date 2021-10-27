class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.25.tar.gz"
  sha256 "55362c01ca01e9c0714d2950c32ab9a473065f299d5d000fb81339a468431312"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9266653cd2e111ce17a5371cddcc28685b16119deb0af44c51c74e3c47a134b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c00024b499c64df27a4374addb70eaf258e157c1e0b15be7ab504909a22f3e8"
    sha256 cellar: :any_skip_relocation, monterey:       "95174f14a2788d635ae891a3f31e3be16cf8fa31146ef6692c00c1612059ed96"
    sha256 cellar: :any_skip_relocation, big_sur:        "f04abb2515153ffaf972a197e9cdc771ba536cf33d48f82459a5639bba1ed56a"
    sha256 cellar: :any_skip_relocation, catalina:       "830dec446da4081084c5143bbee3408264ddf755337c0f0ba77f24016dc6a29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6144b420c60897faf0562bc27808875351f7478c53c8d1bbfe74aa310a1f4b4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    output = Utils.safe_popen_read(bin/"kompose", "completion", "bash")
    (bash_completion/"kompose").write output

    output = Utils.safe_popen_read(bin/"kompose", "completion", "zsh")
    (zsh_completion/"_kompose").write output

    output = Utils.safe_popen_read(bin/"kompose", "completion", "fish")
    (fish_completion/"kompose.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
