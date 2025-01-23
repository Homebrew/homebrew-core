class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.30.1.tar.gz"
  sha256 "ad363967b6a34e02812e4cba36bb340f377cf64a435e23f6e8e9e6b3f775220e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f8670a47423d2d9ab75cc3dcfc0c7b5996120cd2a2df56f5a54c79904c5d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f8670a47423d2d9ab75cc3dcfc0c7b5996120cd2a2df56f5a54c79904c5d17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30f8670a47423d2d9ab75cc3dcfc0c7b5996120cd2a2df56f5a54c79904c5d17"
    sha256 cellar: :any_skip_relocation, sonoma:        "818de028c8fc955fb8df9d1e03f20ac8f792f1f9265b3b845d74cb19a6fd1a12"
    sha256 cellar: :any_skip_relocation, ventura:       "818de028c8fc955fb8df9d1e03f20ac8f792f1f9265b3b845d74cb19a6fd1a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdc10b86df052f39e3fbbf431d05492e410808cf6c831ed653a862e484ae8b56"
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
