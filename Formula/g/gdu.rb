class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.34.1.tar.gz"
  sha256 "d6231f0411a4550b5aab5dd10691fe1c2a3f8ad2911f13706e2b79a0bff281ea"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29b2e96c92ff991b8e8a7b7e8ca943178ba6f0c3bc2b5f7476a7cbadfd9943c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29b2e96c92ff991b8e8a7b7e8ca943178ba6f0c3bc2b5f7476a7cbadfd9943c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29b2e96c92ff991b8e8a7b7e8ca943178ba6f0c3bc2b5f7476a7cbadfd9943c"
    sha256 cellar: :any_skip_relocation, sonoma:        "78413183289a61a5fdb6b6f0752d4f5ec936863f47ae649d32dec8cb49a1f74c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99de31e5c1e0fbfc9591f17e64263eacb3caf661ae05833b44032a1d1565dda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4711555d4b462ddaf97df421c1bfd84f49b33ff3e97aa025b4c73ef75d73a636"
  end

  depends_on "go" => :build

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gdu-go"), "./cmd/gdu"
    man1.install "gdu.1" => "gdu-go.1"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `coreutils`, `gdu` has been installed as `gdu-go`.
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir/file1").write "hello"
    (testpath/"test_dir/file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end
