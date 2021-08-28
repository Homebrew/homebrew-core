class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.6.2.tar.gz"
  sha256 "7976d81c3fc244e9d80a6f1d1b3fbea013dbc7a8bee5df08456eb99e00fb292f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a3d89e2868e7fb578d081bc267be49aafefceddd8303e1c28c04146325d2f92"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb779fded528c549a5e83c4a9b0e05c36d35780877c88a6d825732e7cfa14942"
    sha256 cellar: :any_skip_relocation, catalina:      "594b1146b353e54b1f5a2fcce320e94ba55bed3aaec9b4962997ddf148c51684"
    sha256 cellar: :any_skip_relocation, mojave:        "90c2e2b024ee53467a1e5baa5823ee7b670d7439222b6e4fcc8837b7fedb08c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab9756ecea28449c3abcd85f387517e92e24e96e11bfe83a086256fa531fa23"
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
    ].join(" ")

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
