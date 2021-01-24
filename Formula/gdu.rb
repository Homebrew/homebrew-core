class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.3.0.tar.gz"
  sha256 "8952f866948375ad1465f00e78b30a093799f1433a1ddf013f4143cd0883374a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e5746cfa2afd2458800220d2b478fe07dd21911d0ada01f9737d55ee85ed517" => :big_sur
    sha256 "d3e3e3989399810fa5550a2e1f32032036bc74251ef0dc79a0d6fca7b5961b73" => :arm64_big_sur
    sha256 "e7e2afe19bba9aaa83446b9028b3fbad312f3fe81284b7f1b6d7d98752a463ac" => :catalina
    sha256 "37aa883b5d3ed0f1c3ed23ddd7360605d8803a9ca8af2bf212b37f7507c07f45" => :mojave
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
