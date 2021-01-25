class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.3.0.tar.gz"
  sha256 "8952f866948375ad1465f00e78b30a093799f1433a1ddf013f4143cd0883374a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "03d9eb86c18eb93e303dce0e08cfdc3c17d5e00f5ecca17fdfa861def8dc76c7" => :big_sur
    sha256 "b569c7c626c3ffd54a46347fe6457040285bdd66184ec82d199277735e6efbff" => :arm64_big_sur
    sha256 "9bb28d94fd206b9e9b11bad4e0d0bd6c14c06221f7726027a58a940b2afe98fc" => :catalina
    sha256 "9148f48f0358476ced2c27b685aa2a2eb124837e8d8a55b15035f9ed46bdbf10" => :mojave
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
