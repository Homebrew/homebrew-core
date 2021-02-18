class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.6.3.tar.gz"
  sha256 "dbc4564394ba76f08525fcea8b71d69cf26868efb0ac6d55fdbe43f0b16617af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c8a3f6e65b8e12cf8525c168623145a90d77c046bcea80dbd9ac228795496fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "e59fae45b153a68c02d9142c40e778ea72ac95e2b661a0d625711e985a119e40"
    sha256 cellar: :any_skip_relocation, catalina:      "e698b13d1b31fb8f080ba81b033122d03780da72245a8736da53502fe709a184"
    sha256 cellar: :any_skip_relocation, mojave:        "5ebfc313f94a56ea63b96da8e6ccaf3d7ead23cc97715fefa674ac077b8705ad"
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
