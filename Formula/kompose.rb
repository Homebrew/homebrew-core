class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.24.0.tar.gz"
  sha256 "368c45ffdebe70899584e007d02e4a8ee70c01cc245a2baf021e4ba3a0254a06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6c6cf13bb9035c5536e67d7d155c4d69c36eca7efc35da12446bcb1ef36642b"
    sha256 cellar: :any_skip_relocation, big_sur:       "80c55ba074b4caa1f2867b12e3359f0440e4d55f47358c95a50f93742ee43260"
    sha256 cellar: :any_skip_relocation, catalina:      "270436c38ed7424db632632cc0b74dea070a622ef3ed0e115848718a9eac05a5"
    sha256 cellar: :any_skip_relocation, mojave:        "4856485d9b79a6f7969abca0cbb346495737307d8683fafacfab535bebe4477d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d214ba19e5783b4ade888a032a7a34783b785875c50ab42286c368b2204658"
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
