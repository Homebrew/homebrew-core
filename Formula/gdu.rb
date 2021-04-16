class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.10.1.tar.gz"
  sha256 "8d399b898fd0c5b38153c7a3794a0693fd66fce324c93e58fe88ed76e991da65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af06ef89ddfbec04cae9c6adbfca46d5d10438c91a5032eff6d3eb068179e51e"
    sha256 cellar: :any_skip_relocation, big_sur:       "14107aebbac4918f703c4f6b4f577dfc94b4de0b1f441f2a3a8fb6eb3eae3606"
    sha256 cellar: :any_skip_relocation, catalina:      "f869508b8db15a5aed06d6e598679c3e7d0c2b00f6007e223eee29791fa35f5d"
    sha256 cellar: :any_skip_relocation, mojave:        "dbca9c794a578df461f57edfae03448e262d9a59be740003012fd98c9918bd5c"
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
