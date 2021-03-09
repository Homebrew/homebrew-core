class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.8.0.tar.gz"
  sha256 "6f6bbffbce4b32c128fe35da50f59fffc3332c6b7fb11d16f06ab2a9cf167cee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98fd1f752a783237c9987a011c4296bd49d60f0e9ca4c01fa54f4e17e6a01ff1"
    sha256 cellar: :any_skip_relocation, big_sur:       "07c3aa2b6500b8d7548f365d509e89c183636675cf0974f2d1482d40654ca024"
    sha256 cellar: :any_skip_relocation, catalina:      "d9bf872ee85e2b00fc2fdccdf24c47a5095d3e93b7613a0c233dddbe55a56ff3"
    sha256 cellar: :any_skip_relocation, mojave:        "d32bb6a39405edae8e243350622c42af5d9d99112790377e30238f0978c1dd0e"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/v4/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/v4/build.Time=#{time}'
      -X 'github.com/dundee/gdu/v4/build.User=#{user}'
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
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
