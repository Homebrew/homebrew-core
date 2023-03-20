class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.1",
      revision: "339c230ab496f1bbbc7aebaa1c19a1ea66a9d29b"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4862349ad84180e4af4dc9114559a8fc6c8703f6c1e7a8ded1cfe2505a0de74c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c99383da4ded4222fc2ccea56ab789d6e7ac2090841fc6a8c6e5749433edc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8e477b3d04a0f6cbcf7a7d60a8fcecc00c0ea33aef10b1200b220cc0d74190c"
    sha256 cellar: :any_skip_relocation, ventura:        "d9c2599ddff0a99d36d5dc7ad7f3f80ee5535a051c4e8d7b9aa2d5ce9bd8ce88"
    sha256 cellar: :any_skip_relocation, monterey:       "de4b24266103aa58b9b212c4f8e630d75fa4003003b5fecd39b40d4cfa145a19"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfe11f28b1d0fe19d97acc9b8c218a8aad52c2864117bfa0dc467f3e8c075813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dfad2918ebca75a764e8b6defc48f7b9a0d1a6ca6dc22c7004c349419b58072"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
