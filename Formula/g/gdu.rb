class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.39.0.tar.gz"
  sha256 "1ee1bfacb8771ba8bf094f0f8be31f2749066882a2f1f73360c664d82bba6e4a"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48e974ae1efdb197a2232ff9879859ca3ea1f73ec6736e0c9f523bea7b53d224"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a71f9a0640f01accaa779fa9242b633b02fd0e6a78a551db5f33f798cbff9113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d124525e284fa7b4a2a989a8f468d19ca3b0625bd3b2daa58f661d937cf2c4aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e5878757751a19aa6e4de5bec0ea56280d1ea1e3b6523621a441c2f3d5b6070"
    sha256 cellar: :any,                 x86_64_linux:      "356a1154ad93d39bee4c4c67abc18fe5011bf7a216299ea2767c54266715ceaa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
