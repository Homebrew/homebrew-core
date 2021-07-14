class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.23.0.tar.gz"
  sha256 "cd23a5b7ef9189464800a89f7c1cc80ed745ba157ad00506a9996017879805bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e88ec5c4453630a33b8ec26fd9660b49c904cdbcfe27bc2aa1744201d9415faf"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0429863b87e1265a48140cdfd6315712e13fdfb9f18dee1f4e793055ef33d6e"
    sha256 cellar: :any_skip_relocation, catalina:      "34da28575e40dd6c1bb1fcb36e073aa7d8236f4d8c16a33876cdaa2bcd4f7af2"
    sha256 cellar: :any_skip_relocation, mojave:        "2f6bf388c3aa7d51a9151f39378911b7d1a6cd16505ada04eba05b7b65e7ec78"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8f727cb8dce4e8f5090c856ef6725f000d3618d6129868a0057293e449f1c79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2dff544b0664032c15a51ed55f52167ed6c5ee8be7fd636fc146f5ad4c04f00"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "bash")
    (bash_completion/"kompose").write output

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "zsh")
    (zsh_completion/"_kompose").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
