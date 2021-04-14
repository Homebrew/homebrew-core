class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.10.1.tar.gz"
  sha256 "8d399b898fd0c5b38153c7a3794a0693fd66fce324c93e58fe88ed76e991da65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90b7670ec11cbb4db261b327d04699c89c43fa8c384b93fa1ab5a172ef38fa45"
    sha256 cellar: :any_skip_relocation, big_sur:       "9af37b330b0d64a2cc96927f4bd9b005a2c492f8bd084c0a1df531e7b1f003c2"
    sha256 cellar: :any_skip_relocation, catalina:      "6a3774235dbbb7141fc3498d4bd6117f59bc7e8a04b3859c70e1d171cfbead87"
    sha256 cellar: :any_skip_relocation, mojave:        "1c422dee546bb3d0e0b253e54d6e1b5fd11bfe4b6bdc119ad604e7979ef55156"
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
