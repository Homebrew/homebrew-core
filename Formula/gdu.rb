class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.9.0.tar.gz"
  sha256 "fcab78ac1104b6e4036158a5d3a715494443cfcffd1c21e2237717c9e6baed7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f94377501452b50721c0785602edee6890ceba19fa3799cb80029ac715d7fefa"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca60ca0640852e34650a016ffc28ab3740860af15f30bcc59eeedc4680f6e14b"
    sha256 cellar: :any_skip_relocation, catalina:      "18900c599c7d91c3a5d51cc9094b22c8b3126a1bcd907dc666a229d8aad59243"
    sha256 cellar: :any_skip_relocation, mojave:        "e60e2318697362465d7783fd8ab6a8e0f39ad5a363fbc2df2e1a5b8461e62404"
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
