class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.8.1.tar.gz"
  sha256 "c96a367e91742f1aa58dd8514ed22a9e8904e5ad4c0e1e38019fb525bc3bee76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95e8f94f3eabd4d275699017e1daed565d6452bbe91420145a5d8a4d35a5461a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c09a5a8fc53003f8f300815885b5936aa08ca86b64e05e6e97528183b9b4dd25"
    sha256 cellar: :any_skip_relocation, catalina:      "2e9f491583e2543b98b3344b2abf32d9e170dd170e50207bb03d23fa3179f60f"
    sha256 cellar: :any_skip_relocation, mojave:        "b5ca3061f039fd428d8827d2ddd9e3207bb1b19fe5c79e22103d97a3a4eb1b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b01eeb32838d1467dc568e78f1df9492b95696aa52b1e287b7db5e5ef5c6b1b"
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
