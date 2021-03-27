class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.9.1.tar.gz"
  sha256 "02680848ccb4b2571ee672a874305405a33dc2cace235a7240f8b2d51e2f3501"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a746cca051d15578b4b4681cf49d7450e668b0b4f488edd3ffc7e69098cea7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffd28890daf9200b6b57fd8be40cc26a8c52d197e1a36d21c45644bc44c6dcff"
    sha256 cellar: :any_skip_relocation, catalina:      "78570b9c126f48e08e8fa8965f324d23bcdeb1166d64a40e18b867d780a3259d"
    sha256 cellar: :any_skip_relocation, mojave:        "e113d514e6cafa55f9ed4637d31f2be6f80c0d25ae5866c7fa662f4f9e3d7236"
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
