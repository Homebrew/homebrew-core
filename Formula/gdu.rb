class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.11.0.tar.gz"
  sha256 "bf47786642cae3359d918758f4527a10a80e01805566bec607bc8c2d8f35d4c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f95e1c4d9f8f7e8e4188762cc47f71759c3fe7e1c9f2e388d36a48d525d4ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4924de1739abf9969f0cce187fec87328ea753799f4ba30bc40a4034ea96ca0"
    sha256 cellar: :any_skip_relocation, monterey:       "33870bde3d31712fddb1bb68fbac2e3354212bc15714eeda2ee249f3435ab344"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9b0580a57f923fa659a6ef58063ce93e1dcbe47849e297f7b4d0095acf3d492"
    sha256 cellar: :any_skip_relocation, catalina:       "417a46e9f0ce11d853489a445a1ce1c88a63214abbf81477007eeb9dcb0cf4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9941936914616fc7c86ed4dfddcde33d499e97ae599850584d5bb08362681075"
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
