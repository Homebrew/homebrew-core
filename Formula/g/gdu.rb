class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.28.0.tar.gz"
  sha256 "b184046e76a97f4205b745d431655b7910f8c7b41a8592d68c4cbf61e3b14125"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d5a14d7c8dbbb6af220db7cb19e2afaf44fad0286fac1d9086d5a06fe4ae969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "994dbf2887bc5fd879d49545d5ecd98a8aa825de0e24b61a8223b5ce562eff6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b02ffd215347cf18b7062098763a72b09c81128965f3759e8f0a20ad5a0cdd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bf9311c8380d46bee207edeff761fa87140d7f0927fd7ebbc2eb4aa6304f4b0"
    sha256 cellar: :any_skip_relocation, ventura:        "b25ba3ecd84a5cb3b2523a3710882b53543996a49e5b85f8bdbfc89a8e6bee4f"
    sha256 cellar: :any_skip_relocation, monterey:       "7a40ef760395efb85dc4df87faef35ffe379ac77c9ec0f067bb72725b670da05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aad0a688c4e964c109f8c2ac9fe37ba5e0dd0d71e247ff44a338cc9b0c65cbec"
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

    system "go", "build", *std_go_args(ldflags:, output: "#{bin}/gdu-go"), "./cmd/gdu"
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
