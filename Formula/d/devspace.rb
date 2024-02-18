class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v6.3.11",
      revision: "e6293eb64be9590f2947e4315e5c8c3a91c48a66"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00158c2c2a36b1ba59543b8b962520c64e5dd5b5fb78af226a393232690a3a5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc4e0d931c8caa58c0da24ba94736abcd14fd0785591459c5aac6fecae04f6c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26a3c46eb16081338c31ad7c2ac0b4524978a439a601e6ff7267d13142f8ca84"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c24cc51a9339c2771afc99b3fc4c0903a9ba5447451ca6f3b14b818eb02d938"
    sha256 cellar: :any_skip_relocation, ventura:        "8c013f6c7938c4ce1ddc407f5604bc36beac42b82da23460e453b94a13522ac1"
    sha256 cellar: :any_skip_relocation, monterey:       "841657112e3096af2276088fb2d4dcae849c6c5c46f085012c0909bff46db794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9797bba65ef73030cbe550df894a7c2240aaab9747f1c607396af90952aa55e"
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
