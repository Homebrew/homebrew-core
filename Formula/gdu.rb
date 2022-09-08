class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.16.0.tar.gz"
  sha256 "266bd635d3b5a676f23dd0a9a599d7eb54ac56d5b6aa4ace044b9a3763cf9783"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "611bb21fb2e4ef80d21aed07dd8580cd1ed5af3d264729330892e17555bc145c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "106343c8244071814131fe171e60956c234d9de13b802c70c48e5f44b6d30fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "9c7659e2cf2c5745ccca64fdb8630fe36a5c25ef8e95286848988bd057580a88"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fd9a1ce122498f63c9a774a157f887e73a0ad0689e20b4ff5ca255243522561"
    sha256 cellar: :any_skip_relocation, catalina:       "a87853cbe450589967e30f0327668e4f1e364ad5d1de12af6c9606668d37db6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dba6a2be90a633e0410682db2df264f2adce88f90a8a498196fce93de9b0d09"
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
