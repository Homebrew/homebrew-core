class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.13.0.tar.gz"
  sha256 "efcbf98b83adc99777f1e135abb61f747dae32b04919fdb884dbc6a57d6ed5f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7689d951f075797751ccaf741cace09e8742bab05d0418e2537044f8e84ff315"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "379da9270485a49b42a789afb0cdc963146741f8442749a6c1f313f0f6acc568"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b9a8d8ae537e9033c43eb9a85ce1c0728f2ee640ac241a170df4e0c3e3b9c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "88cb83838761af49d1ed55f66177ef98b1746e217ae06b830b80137d452e7a84"
    sha256 cellar: :any_skip_relocation, catalina:       "a11f709c94ebcee9eebfa8e775e238bd501b0fdb3d3ed1aaf71b45a75edecce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06959b4fd8f8687cf78fa681dfe9e584fbe66413955e949eb0bb93d33f5c5641"
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
