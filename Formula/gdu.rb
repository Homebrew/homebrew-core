class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.8.1.tar.gz"
  sha256 "c96a367e91742f1aa58dd8514ed22a9e8904e5ad4c0e1e38019fb525bc3bee76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "644370c24f2d61d889c6de2a93ccbd072b4926b1e8da491a9973e139536aeacc"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c34934e7fcd4f09e1a6c6da69aa53a4d49a609fa505d1066b7fcd9868425920"
    sha256 cellar: :any_skip_relocation, catalina:      "de2c03c9297eab1c59b64070a6586bff2ae6d3ad1e66db930791dce3415e9fff"
    sha256 cellar: :any_skip_relocation, mojave:        "75962f4b79f963f392e5280c2bf20f8162742913f7a359538ee60294a9263ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e2e1190f5cfc8a7ca482dcc40d73641c4b6d44345e82415920a12fd6cd23c2"
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
