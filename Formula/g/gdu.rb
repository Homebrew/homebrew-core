class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.37.0.tar.gz"
  sha256 "48e20d39a1bf706b3e11bbfeae550a0890610d3e6030a73952903f5fcf062347"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c4b4a14ba21ed7b64e559fcded8270b5601f0e08bc8ca354b4581002c652477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5af0d6ab4cd0fa08fcff0c6af24847e12647061577fa2eea215bdaaca146057f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3889a28bae2f083b01b6cdf59cbf4b2fd47c4e01808f3c5e15f93938161f183f"
    sha256 cellar: :any_skip_relocation, sonoma:        "97bf3e1a963714c7dcac61eff9347d2a8c48ad9059e58acf46712cd4fd593802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e492034ec1cb80396d7c150d9dd0c44361afa0648ce3b71d5020a4dfb54ae8ef"
    sha256 cellar: :any,                 x86_64_linux:  "a3a2b7c01e473a0962095e8f824faad4a56a4bb7d1e4ea3ecdb144399fd95598"
  end

  depends_on "go" => :build

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
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
