class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.0.1.tar.gz"
  sha256 "bb0f430f3c9007a39f402c143ff3b0cbb4b425ffc794d02ca20241afb452e2f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69cc2511e3f49853bb2aba0a596aadc3ab17ebc1b6b5bfe27b178bea37c44f80"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f895e32585e6462f92bddf5affe12e956451b4eed762c8a589be5ea5b9ad973"
    sha256 cellar: :any_skip_relocation, catalina:      "7e10e04f9d5bee8781d252555c2b79fc550e219881576d8747f082e817bd67b0"
    sha256 cellar: :any_skip_relocation, mojave:        "bc39cc6b9cf1c88d2fef6ae96dad5775bc21ba500c8ae338f598b816f6f113a0"
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
