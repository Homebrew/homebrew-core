class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.5.tar.gz"
  sha256 "dd9f19bb4dc9b8a06bb839dff91eb69833b2b9c77a9bfe82fc8caf1f47e97df1"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81dce6423988baab4f4ee84e0a331145b31cf864ee8ce9483e921799a1f7058c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b41e6792cfeafc02294372e5cc85f202d43ffc54e345b44b59e2dd2b5d955211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6c8c1b1100cc6e28e53bbdcdb6995283a42a25e8e3c656b99f4ffa2575ec07d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a83d3c086b1e0672261036191e402c105909580856df4f7d44d9b5041f6ab9dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb039186e9f2dc2edc6ac804f3420c6edea16419847fc6796b43382004a5e23c"
    sha256 cellar: :any,                 x86_64_linux:  "ae4ea484f515936d96ec9a5e5ddc244c6f822518ec779b23a3c40c861fb748b9"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.5.tar.gz"
    sha256 "f3e2a3840e0ad36089b24b3dc83e7f8c99a769b6bdb9e89fd2b2d5170a405fa2"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.5/i18n.tar.gz"
    sha256 "069c9a01297c6833760a57f2179b06161cb956e81df991d6d2c157a468cf76cf"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r Dir[buildpath/"i18n/*"], Pathname.pwd/"src/lang"

      system "pnpm", "with", "current", "install"
      system "pnpm", "with", "current", "build"
      cp_r Pathname.pwd/"dist", buildpath/"public"
    end

    ldflags = %W[
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.BuiltAt=#{time.iso8601}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GoVersion=#{Formula["go"].version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitAuthor=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitCommit=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.Version=#{version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.WebVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/openlist help")
    assert_match(/Version: #{version}/, shell_output("#{bin}/openlist version"))

    test_data_dir = testpath/"data"
    pid = Process.spawn(bin/"openlist", "server", "--data", test_data_dir)

    max_attempts = 10
    attempt = 0
    http_status = "000"

    while attempt < max_attempts
      sleep 3
      http_status = shell_output("curl -s -o /dev/null -w '%<http_code>s' http://127.0.0.1:5244/ 2>&1").strip

      break if http_status != "000" && http_status != "000s"

      attempt += 1
    end

    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    refute_equal "000", http_status
  end
end
