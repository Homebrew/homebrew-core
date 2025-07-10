class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "425f551c5ade725bb93e3e33840b1d16187a6f8ec47abfe4830deefc5b70b2f8"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6c118923f5445e2110ec660827f6646dc64faac90017d3e11421ed9a59a5947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e133471b318f9fe36e580557417545e05919220f7a0e3d53169e32cdf32c3fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29a8efbd837ae8cad28f1277874986c322cd0ca7b67f99c5afd2daea7a284127"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2add9d606281bb8e8dad8d56c6595c54a8b39e6b9e919f92bbe3cf91515546b"
    sha256 cellar: :any_skip_relocation, ventura:       "6534cdb920a75202b6e628ac89ff7033bea173bce0feae6d7785622eca5da494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4daedd3b463cf677e5880c5e856a17bcc89d40c55d8fbf5222a3ca59afa3b9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c40095f2780cc9fbdba1b8b20708599b9903484c306b375ec4a94d57cdfc2f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"plakar", "agent", "-foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output(bin/"plakar version")

    pid = fork do
      exec bin/"plakar", "agent", "-log", "/dev/stderr", "-foreground"
    end
    sleep 2 # Allow agent to start
    system bin/"plakar", "at", testpath/"plakar", "create", "-no-encryption"
    assert_path_exists testpath/"plakar"
    assert_match "Version: 1.0.0", shell_output(bin/"plakar at #{testpath}/plakar info")
  ensure
    Process.kill("HUP", pid)
  end
end
