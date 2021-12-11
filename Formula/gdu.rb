class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.12.1.tar.gz"
  sha256 "81471d80aedcf20c84bcee67814d34ab2cf43477b831ffa320b7721d481c64ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c54f67a5257127abfd8a98ada77e785fac0d55096710737b31d7a6a7c620fae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b6fb35504d3c697216c8fb8f224d9217f6abdaad1aaf7425709308d0c68cd0"
    sha256 cellar: :any_skip_relocation, monterey:       "85d6aeca0b131404ac0ecd32841d6a7ea2fe8a5d6db9fbbe0897de32eeea0e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "32dbf8841de48d6fa97e39156d749a8f02e1fc2f2dc4de156c5387c3214df702"
    sha256 cellar: :any_skip_relocation, catalina:       "2c2ee20a8605b5cd253594269eff2355e21752dbb809fe85e5eff29d7fd4c699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaedaa697347043c82b7fdf8eb6c02f41780577c63d3e8fe6a4bd3e3892dcd04"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gdu"
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
