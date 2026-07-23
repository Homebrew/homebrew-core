class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.63.2.tar.gz"
  sha256 "a2602f00b429325f37efedba5e67918269f5ad2687266629dad23b740135cd4c"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6a5c34510a05cfc77c69946557413d9fd17a912ae629f280f51a99dba94f17e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "224fd0685025a711555dd52a7aebdff54d0f05bb2e79879b0c41f013132caf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c471eb99460303cd65f5ee390738c2fea71ddd46dd93b1efd9b53426c962b6df"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc4cab18aa31487a00f147808d4b41f45d17a46c004b7c8936d2ee89a9501e0a"
    sha256 cellar: :any,                 arm64_linux:   "de010186ef07469d275ddcd9668731b4627b88363c3db39b69ac3a626935e0d0"
    sha256 cellar: :any,                 x86_64_linux:  "f41af6129a9f714e99b7e17c852ca17f7e23c050b7401a0e920a62deb965c162"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo,sqlite_fts5"), "-buildvcs=false"

    generate_completions_from_executable(bin/"navidrome", shell_parameter_format: :cobra)
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
