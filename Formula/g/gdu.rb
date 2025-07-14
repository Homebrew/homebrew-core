class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.31.0.tar.gz"
  sha256 "e3727680ea346ce86e63d4c97841cbc5e17c6d8e58fac8b8e9886e3339214e9d"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028214b990af856110c71589131134789dafc07f388ae587090367fc9dfbb755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "028214b990af856110c71589131134789dafc07f388ae587090367fc9dfbb755"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "028214b990af856110c71589131134789dafc07f388ae587090367fc9dfbb755"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c127a218822480fdcdc715b6213cf4d54de229910d414e40d1f6d61b58dd268"
    sha256 cellar: :any_skip_relocation, ventura:       "0c127a218822480fdcdc715b6213cf4d54de229910d414e40d1f6d61b58dd268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1aaedb058ab6ecac1d0fd814dc09971a50a81d22fde698f610770520b91386"
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
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end
