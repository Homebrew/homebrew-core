class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.5.0.tar.gz"
  sha256 "7aabe063f6f0faa51a8427d37585464afba19b528dbf99f336ab114d20a262e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c86f582a5b9678c45cdf29bc813361a1ea30699ca5873a0794890d8f80a467f"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd995972fe6f0e9f316351cd96779cdcf61573a0e843a55397e609bad11c4a6f"
    sha256 cellar: :any_skip_relocation, catalina:      "14d1c7fa9f378f961fa963f756a1566aa48df0bc91693bb8e568c2dd1c1f3e10"
    sha256 cellar: :any_skip_relocation, mojave:        "82e26c3393b657259429a15b6ad03d4c7f5150a7b31288fbe4c84290c73bdca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2d01efa1eac3e2807c824a21228191caaa6d061ed47272a3e68cd9f4fd32d1"
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
