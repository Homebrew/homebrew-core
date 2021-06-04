class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.0.1.tar.gz"
  sha256 "bb0f430f3c9007a39f402c143ff3b0cbb4b425ffc794d02ca20241afb452e2f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba288a17d92eb7c189230d881974afe66c072a230f309120bff28e84bb4048cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea357c764ba372746025c476b181d0a239218524879752b4db51877be2af5a0a"
    sha256 cellar: :any_skip_relocation, catalina:      "cb8e7057336924ec7a6e38ba517e5a0161bb31bd1d64e1794c3c77b519f2ad2e"
    sha256 cellar: :any_skip_relocation, mojave:        "d7d9f804949d8cdb5eee465599e55c1d82c82beb6fe37b7ba08dba912d53e49d"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    ENV["TZ"] = "UTC"
    time = Time.at(ENV["SOURCE_DATE_EPOCH"].to_i)
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "github.com/dundee/gdu/v#{major}/cmd/gdu"
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
