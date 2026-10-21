class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.38.0.tar.gz"
  sha256 "44589852e4b1a82fc766182f654e4269d469ec2f9a9f2755a72a7991a5a5ac37"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81148adb5a876bb46ddb366e0aee802602d607677ca53e4fe885c37db91ae35b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31f13067a9e650f4914cd674e58f26e2a13773541b81c4f965ba447c3d856ef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac45990f6d9f9271e8d56a61a250ebde5a39eaeb8bfd9340246a055c985a89ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "287d8a2596c4418ea43e422ccc8d6ff90e7b1674a9a28b018913eaed9f5de66e"
    sha256 cellar: :any,                 x86_64_linux:      "b35ee0126abbdd6c4e45eefad9e15d94c9ac1d8dedfc19526b70d7896e8ed162"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gdu-go"), "./cmd/gdu"
    man1.install "gdu.1" => "gdu-go.1"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `coreutils`, `gdu` has been installed as `gdu-go`.
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir/file1").write "hello"
    (testpath/"test_dir/file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end
