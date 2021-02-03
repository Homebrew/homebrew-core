class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.4.0.tar.gz"
  sha256 "e44f678e973c2d09b47b14934854a95a0413bc8f6d1996c2e9f1b6c1f04237ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a28fb7f5d4e5f1a61f4a8e0d6854bfec1ce2c5013e710ee6d819843f75265b83"
    sha256 cellar: :any_skip_relocation, big_sur:       "fece82f65fc7f1a6d666edeb7dd3783088ad5e3d6cdb30c120f0c90de6924af7"
    sha256 cellar: :any_skip_relocation, catalina:      "f4b95409d76143315221772bacd1b15b2fdfe7788125439d12aa38c8aa37cc01"
    sha256 cellar: :any_skip_relocation, mojave:        "6bed66d1d401554d0cc461e448ed5e52c8ac6dd45a1d7c7f866fefc8fda333e2"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/build.Time=#{time}'
      -X 'github.com/dundee/gdu/build.User=#{user}'
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
