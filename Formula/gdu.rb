class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.18.1.tar.gz"
  sha256 "a841230f59243965c6591d40761b624d1df207963f2cf29bda0fc6c1645ae9be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b132f7ad1c16aa208ef271d3860147d1373c2b8cf800fd3ce895d4cc02277d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9aa29ca4ab84263fb6f5ddb5b615782623df06491e81c750b124b6525f3548e0"
    sha256 cellar: :any_skip_relocation, monterey:       "f6a1ba7d4ae7bd0e1c4c42c06435c9e1e0bf56ab851f1d6c9c0791161b10c7df"
    sha256 cellar: :any_skip_relocation, big_sur:        "20be8821cb5ff020e7f77cab97f687743f0a9ac2c16d0bcbfa76bce61a87f1e9"
    sha256 cellar: :any_skip_relocation, catalina:       "c7e355cebc5bcc701f2ddc16347311e4e0336ae72db471bd1395f5189f151d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285bf081422e126bee3915b8d7d4dbf8143e813c42d893940af6ef5a91da59fc"
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
