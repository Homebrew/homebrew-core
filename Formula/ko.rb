class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.11.1.tar.gz"
  sha256 "eea43334df556fd142a9323334920443ce951bbebf87b945d64c4ed60e1e83bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c50944de099f420cb6426c57085db04eb092f7d3198e729e556faa89d0b3161"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66d67a33dae669561060043d6d2c737aba508000afc1954c8a5377b82e3849d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9a812e94b1491ab33cb11685138e40974c6f1942cc85ffacbd2c014b39c1f184"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ea0c16cc2802e99eb3fd80fb52f0f283f9dc5825a29ce0a58db5e778d48b82e"
    sha256 cellar: :any_skip_relocation, catalina:       "3c706bbaf82a39790e5093ba3d595a963a67ba6305a4ed59626d741c3098b584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33d51584e50fce66410e4bf8c2dc5ad33cc159a192275cdae10696caf4d0667"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"ko", "completion", "bash")
    (bash_completion/"ko").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"ko", "completion", "zsh")
    (zsh_completion/"_ko").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"ko", "completion", "fish")
    (fish_completion/"ko.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
