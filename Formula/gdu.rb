class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.10.0.tar.gz"
  sha256 "c3c4973e621066aef23115710379953c5f59142d495c69c9b102ce98faf2291b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26b6707064002db32f41618df178c985f386b9477064fb00b99873d49a72e197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7134a168c10288600640e4543985e0f33cdfd19e857f69b8beee414afdcd46cd"
    sha256 cellar: :any_skip_relocation, monterey:       "7fa3e89429ae71dba52da97bf75126f1c74a8f6002d3b50c48acbb17f66548b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0ed8858d929c7affefb4e52f9338f957774c69e035020acf2af7c3d9d818c7d"
    sha256 cellar: :any_skip_relocation, catalina:       "4600b82cab5d17ac5313e2029e2bac217306948ab9b436a1ead187edb19e9f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be0d435ac140482794486cd44aee8b728816ff398fb603722d0444abdf7f82e"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gdu"
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
