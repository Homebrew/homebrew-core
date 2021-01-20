class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.1.1.tar.gz"
  sha256 "c2fc1f57ca330e0a319c90cd89d431640ab098591ff4e2f2fb79197a5067fcb7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "11fd0e8fac29c8bd7a7050ec9b4d874c94cfbdba1e9ccf976052f44376c5d57e" => :big_sur
    sha256 "f7bbf2ff7b001283766f7b719c28997febcb229b2f2879da2b7019c57e30a6c5" => :arm64_big_sur
    sha256 "08fee5f6812d031059cfbb6936c1c94dfd22c27c275dcd3f6e0a7a7ea1f2ccdb" => :catalina
    sha256 "c15ef7addc923aaa2cf4861d11c470f65c021e4fabcc765a17ce8888c4145d28" => :mojave
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
