class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "8db84c35fcc87e0a376a44e7406d6168a7c90a588c7a4045c6ede272a5d9a3c2"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24558ad7b97461868b11f0a4875f3bc651bf3e0c727904e11a415ec29d6457cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f98d158a36c9db94115d9713bc7d263e7804115c76d6a71b1f240291e5c5f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3770da7df5afaa4df02e22706dec62fbc7aa1c94d491a99894357ce19553f061"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a2c4909cf0a6bf4b8b16e05a896cddd65d46807dfe2e6fd43f8792377a7dbf9"
    sha256 cellar: :any_skip_relocation, ventura:        "df303dd25f162500037e2e8786a20e8e4347722656e4cc0bb3919b74a3d0eac1"
    sha256 cellar: :any_skip_relocation, monterey:       "2965d400e4b41fa3bfdea618df5c68715afeb0b4723017c4ca75ba8367fb796e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30636912403d2f6ce957c4f8ee66f90e45f58aa534d9ae49bf914b5bf6222b60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
