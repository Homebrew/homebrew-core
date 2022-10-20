class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.19.0.tar.gz"
  sha256 "69c47eaedd0fc1e664d5a08c91e7b107961145aa307d1fd11cf208dfec573f0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ea6c157a0efb17afa4a7a33117446467f45baf4997950c8629386e40f0a868"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33506601e45a5bccd2b6620169bf19e26946dc5e1e9cbde7eea4a033b0104cf0"
    sha256 cellar: :any_skip_relocation, monterey:       "78c05a34ac291bf8b167f7361a896e7d28b3db07f3bdf728a5347225abf7bc62"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dc94648fb915507e29a9a9f592650f35c6c875e42dcbc1e6e8821824664c088"
    sha256 cellar: :any_skip_relocation, catalina:       "f2b69b5f0debf42b104e68669ecda81213c64ad2f6bf3007940781191f8f4ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527844ef7970d7b96ee53cb761608e2b62fc73612379b9c53373f86d747245f3"
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
