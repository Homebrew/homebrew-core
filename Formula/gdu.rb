class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.3.3.tar.gz"
  sha256 "8e5fbc10205d81b2a37c265cb8a29d53183827958c5d14fb4b9a3c670fb82bb2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "329a8ac0d2421c50affaef1848d9ee47f105efa0571db1d18196bd1ba1a4b90d" => :big_sur
    sha256 "9d5cf8cf0eef74c0f9142a1c6683eef855184b74fbf6b784d0ba8708bb42b8f1" => :arm64_big_sur
    sha256 "499397d6b3d233d64e88088b59a8cf0e6131cabe1f07ee0f9f5992f333b29be4" => :catalina
    sha256 "d5191291caf4a548695ac9363ee0e9b38c6e796e145ab0ce0566d94a4fe8a91e" => :mojave
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
    assert_match "5 B file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
