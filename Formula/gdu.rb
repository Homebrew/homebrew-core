class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.6.5.tar.gz"
  sha256 "a6a9be5a29c896814c2266389b7ec76d2f4ad55eee9bb156cf19d77f425ba3cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d7d41199b1b3622daae402d113b511759a85bbe6355306e8e23b2ed74f211a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "5df7197faf23c86ab0fd1093cfd2ce78f127f10c2415abb063bce32670d13808"
    sha256 cellar: :any_skip_relocation, catalina:      "763fd9756ff4e16d015b1d9468bbbc4391cf5348551fe40999ed679c8a00b404"
    sha256 cellar: :any_skip_relocation, mojave:        "a80db214f2511c5a472fb4ec58f1a61b035f227239867dedd753a8a83d30dd94"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/v4/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/v4/build.Time=#{time}'
      -X 'github.com/dundee/gdu/v4/build.User=#{user}'
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
