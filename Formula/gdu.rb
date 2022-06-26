class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.14.0.tar.gz"
  sha256 "6fb64500eb22a4e586322c065e97bed72b6f4e1aead4311dad50b75d11222cdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "456e48db01c87aa0688b8367aacbef7f01e11d23282f91a752af4ec8120a8458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58c355abb8e0133fb2b172d090f2a8968b33b1dd45aead32731efb38863fd850"
    sha256 cellar: :any_skip_relocation, monterey:       "dcd48592c71afca803b7b955e20e16bf064a86e6b73282e7a885cbbea00612ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b8dea6849dbca99bdfaed80558325a3c205c200c86964302e7cf0ec0bcefdee"
    sha256 cellar: :any_skip_relocation, catalina:       "99e63f01de21b143ea04e7436aa5424141c57b11a779669e4406844742ca7e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f579d36c220910fb46ec359f4be3adc66f015165624f796d3ffde87007ccb3cf"
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
    ]

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
