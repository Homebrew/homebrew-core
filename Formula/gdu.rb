class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.10.0.tar.gz"
  sha256 "a3767b84935492191d423da95dba0de7bfe4c9e5242aa43f9d757ff0cfae378a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ba7e855d847c10a7a45915b25150cb1e35662f955959c332db00d67e2a1b9a11"
    sha256 cellar: :any_skip_relocation, big_sur:       "39ea18a9518e7886a838e83d9b005683d95c5580af201f392e3ef1d3dee4cad0"
    sha256 cellar: :any_skip_relocation, catalina:      "65ee6368c0c7e93b3101f7ab7c164d8a94ef6fa1c072660127fe5c4c196d75d1"
    sha256 cellar: :any_skip_relocation, mojave:        "541fe86fe808568a60b723a1892ce428d9acc9203b868dbdc3cfbda63cb1c6c9"
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
