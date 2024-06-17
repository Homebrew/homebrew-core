class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "68a14413df39f78d8e3baeffdac4e3829f0a49f4f32af5efa4a233d7dd25eaa7"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1a5fa26b446be8d4cb89ed6fbed5ffa60c37a61ffedd54b56465bf5a9c10692"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f129d6630fa63062f3dfa488b0a1e8bafbfdd05f30f2915b548b8497a6f728a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc1ca16e2b888738dd0915b55eedc9a2409a3bb2575faacb68b14e5b55f3733"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e306a7852dee5a207297a5b6ded62c1021194239f552530b303258e485d73d8"
    sha256 cellar: :any_skip_relocation, ventura:        "207b2191e79be4ec070a6ebdd412ca9cee89e2c560912f42410539f4d6b55949"
    sha256 cellar: :any_skip_relocation, monterey:       "6668eae28c2d1e58502fe483bbd0982c04284ca61fb93bc0ec10cbeceb357691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57d988f00c4d6b7679eb3ab9bceaafe52da6851bc2583efb7e55c5cca7b02904"
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
