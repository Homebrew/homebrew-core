class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.29.0.tar.gz"
  sha256 "42e972f46e49995be24b223c91375bfbea547f5e8cf94c0364f7b3eb5b0ed0a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ea33b7955f8c425ccb623c7d8e59e71e0e233e13d3808c80c79addea0a899c35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "400253d80ce28d715ab27f9c96bc84a9a0804414fb69175bbcf5a9a784663829"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b1c3911a7ec3bba12be03083d86efc678dd5fe20c625294d7726fb611dd344f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca36ad5c560d8a41acb52e96f183ee41f0f4c6ccd9ed411f48a0eafba651dec9"
    sha256 cellar: :any_skip_relocation, sonoma:         "51ea3cf59e39a9437276f3312e3596a07d361ef0703940401ea9320adde4d46f"
    sha256 cellar: :any_skip_relocation, ventura:        "29ef3699c568681e545d3eee2ce044a329eb2a09955a8dffd1e4c8000cd48f39"
    sha256 cellar: :any_skip_relocation, monterey:       "89c537d2c2f290a401166fd18b108dab0826f6b8134c049f12d7391f7f35c8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a24fe025827b65ec3a228f2e9551d9d5a646eb62e2cb77b892f0a27821d0f87e"
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
