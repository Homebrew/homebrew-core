class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.7.0.tar.gz"
  sha256 "d199a71780c4ee7c88323c054a450ec510f2fa4d36667971dbd7409192ee690b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1bb9a6c97258c9b580a529869ba6863b5fc0e6043112d85922afd12525840fd2"
    sha256 cellar: :any_skip_relocation, big_sur:       "52dae1c25356b63aabba7b68ada6b1f5fcd964457aef1717800612ff994fa9b4"
    sha256 cellar: :any_skip_relocation, catalina:      "3dbe69eb522789e0b88d7b6a35ff8574c45609e7d5d30484cf9b38c70533d4a5"
    sha256 cellar: :any_skip_relocation, mojave:        "a96d1c6f56e188fc8728dc62c14985d769f39d552054feeec1fa3101960c2c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b277a774d69bc9d3899013943f204f3b89a3afb6671b7b96ecea65375d162f"
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
