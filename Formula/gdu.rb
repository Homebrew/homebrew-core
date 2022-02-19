class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.13.2.tar.gz"
  sha256 "f4f237f6da470599f6393591282cfd67922a963325859a939ca40ba7e18024a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3f4187d556d95071a2a0bd948fe50b299f18687fea51d4be2510cf7841cf1ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d22f3fbbf7a5487facdc7dfa31d0a2b608fd8c598c31547b7cb20399befc78a"
    sha256 cellar: :any_skip_relocation, monterey:       "727cdaf579987f813180420ccec231b9818eb99f3f76570d873a69cd7d911c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b5a68c973b81e018afea34bee01ff70b30dc87b10981401c91206642d07da58"
    sha256 cellar: :any_skip_relocation, catalina:       "04ecd763ca8d284823854352fbb7781cea5799c9f2e749cf5bfeaacf20e83806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4d9a2f6b59272249586431b76dde3df9ea8627ab56f2c3d0f20e33d9c47581"
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
