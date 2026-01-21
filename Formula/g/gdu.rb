class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.32.0.tar.gz"
  sha256 "2b647c3b222392fcf25583acd2411ec05635055ef7272c7ab4bd2885e53065e0"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f50a64390e414c0fc7e4fe51deec8d68ca9c40fab1f901e3f558c103618cc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f50a64390e414c0fc7e4fe51deec8d68ca9c40fab1f901e3f558c103618cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f50a64390e414c0fc7e4fe51deec8d68ca9c40fab1f901e3f558c103618cc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "27ffd9ba1c0b6cb62598644ef82e14c11d92b1afc6a769dfb6bd0eefa77ec33e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b18296318dacd64cee755927eed908ca2abb97c8bec8a83aacb13e2cb27f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f8305dc261058f94d0ee330a6f9fcb95160181622ae0148072ef99352a135a0"
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
