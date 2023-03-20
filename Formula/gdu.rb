class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.22.0.tar.gz"
  sha256 "cb655d2c609925fb137357704dcbebf7d80796d9011ed43df8c79c18cfa893d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff7692229c9d322c370823931d36bbb0b2b93cb3f7b023cd6c9fe0bc73170b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "256eb895aec3d8ebb3d57a270b7b126c2ddfada05c510d3c43f26fb279fc9ee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e99da60384722212df5429cfbf05413e4f269c5ae4d83c7891294ffb61421394"
    sha256 cellar: :any_skip_relocation, ventura:        "cb50007a0547e57f3faee3eb9b1946ecc08260a5828e04d1b8c761c9a7c493d7"
    sha256 cellar: :any_skip_relocation, monterey:       "68d9bba3332615de12d682cd17674b4f9583b0729be5c59760b02e62246a60e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "102611e6dfe1167ffeb49193bccfa1d0b7c75f0ab698d78eb091d9247e919ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e250063ff351b32769b7a1ec6553043546a03519e65eefc7962176d3ee96f9"
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
