class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.4.0.tar.gz"
  sha256 "e44f678e973c2d09b47b14934854a95a0413bc8f6d1996c2e9f1b6c1f04237ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "8432803137a63cfe02a3ae605f3a4c20ba11f2a66d87dee4c6366d0084b0be9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4358573ff11e2df70ecf46ff34243301906fbd02854fc67bc804eb87e6aa7eba"
    sha256 cellar: :any_skip_relocation, catalina: "acf678604101a42103d22850ca3e1e9cd9cec29805d2a0218e0f8e99ca82384a"
    sha256 cellar: :any_skip_relocation, mojave: "d4b6797cf0a5b167854ed635d4c620718ca3effa82387aa422051a6d009faf38"
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
