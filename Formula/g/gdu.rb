class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.35.0.tar.gz"
  sha256 "2c0e4fe412a828e1c0f414f7c230b994e44356c4753c3546c67e8178db500535"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0e96d1084684d688c85055af8f0e6d1ed7b254ff895a21720e72f27995ce926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e96d1084684d688c85055af8f0e6d1ed7b254ff895a21720e72f27995ce926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0e96d1084684d688c85055af8f0e6d1ed7b254ff895a21720e72f27995ce926"
    sha256 cellar: :any_skip_relocation, sonoma:        "8132f0b4b39723c4c3b667e2962420c940a383a6409ebc53caf7dc7f4618a864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5664395db3eef2838b323dd03e4ec76dea59b0dae6c0f8a0464fc061031f4244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e9c3e08a1ca1410127b17240e645f0b4c99d155e16b68c14cb5538a39ef596"
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
