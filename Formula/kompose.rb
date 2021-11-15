class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.26.0.tar.gz"
  sha256 "e24db4279d3386700e25f3eb3ae4115ed11f4e0b2eea16d28f2113c71d13fb5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fae1e781bebf43f1bcfe8935e2016cdcf3908ed4560c2700868d3d7ce281a34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11159ca2fd486a6a13e415f8b0104ce67b81bf849a1209531ee91b106e24f966"
    sha256 cellar: :any_skip_relocation, monterey:       "9d9abadd8858189a27d40c7586eaf252ea20966e336d924195ffd2d390e51994"
    sha256 cellar: :any_skip_relocation, big_sur:        "54124d3c5933c7644cf9ad53ec10c8014ad6ad3e031907438a9cf5afa0018e64"
    sha256 cellar: :any_skip_relocation, catalina:       "63f80ee2b91e4e796ec3e334759f167f2ccb656f3cfd464fe0b862964f518797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "387e670a1b49be509660f5001542d44f01c512fb2252595e6c2fd06c17db7992"
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
