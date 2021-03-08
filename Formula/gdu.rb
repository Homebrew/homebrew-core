class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.8.0.tar.gz"
  sha256 "6f6bbffbce4b32c128fe35da50f59fffc3332c6b7fb11d16f06ab2a9cf167cee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5689dab36c51537c5fc3785ded79736f09d3570a60341351b366b3519487a7ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "086ae5e9042211e1c0c614de94b14400f0d9752d4a72ca56b030360e611a1ced"
    sha256 cellar: :any_skip_relocation, catalina:      "22677c1fc211d9bb78bee97dd5349880d61ecc13bd7f0de8b86a2097ec2eb2d0"
    sha256 cellar: :any_skip_relocation, mojave:        "6bad198d193a9f897b0d2118a92107afaa487cd10555b38b5aaaa3bd61c7c8e4"
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
