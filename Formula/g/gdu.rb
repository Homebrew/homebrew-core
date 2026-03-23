class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.34.4.tar.gz"
  sha256 "81aef5ae5f0137794ae0385cd9b041a8772016ae9e19f5f071e17f187cbc6832"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18f4192751f8298f8c2605d61c649649a7a0a9368e13b0535c2a6b4636fcdc54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f4192751f8298f8c2605d61c649649a7a0a9368e13b0535c2a6b4636fcdc54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18f4192751f8298f8c2605d61c649649a7a0a9368e13b0535c2a6b4636fcdc54"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cd0c7f4ede4fabb4aa414cd1020b1c86be7b9e5eaec3b2281596e1440fc442a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f658d4c44e3b436da58e0cb777cfa9ca83089d754942045c53d8076bf8b6f39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04689f69d75f8f17cf067d81c58ddddafbcfe30db7edd5ae77b42862db1560f"
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
