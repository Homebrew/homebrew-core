class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.25.0.tar.gz"
  sha256 "83fe876d953b4f2f7a856552e758aae4aa0cd9569dcf1aded61bdc834b834275"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8a302548e25843ccb7e4e4440a0fc974d07406e37f009e64f1ae832440494fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ddc42b8da31e35f87c722fe3c1912e338b15e4af553e1d0bb1d8ac7a4dd600e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ddc42b8da31e35f87c722fe3c1912e338b15e4af553e1d0bb1d8ac7a4dd600e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ddc42b8da31e35f87c722fe3c1912e338b15e4af553e1d0bb1d8ac7a4dd600e"
    sha256 cellar: :any_skip_relocation, sonoma:         "25d3f8681835c5a7f154aaa0f3a575e0b20cc6437583cffbcfaf15e042ed79c0"
    sha256 cellar: :any_skip_relocation, ventura:        "aa1ba23f987df2ec8403887234196d7d548819f4725935e4333ed9802d6bacae"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1ba23f987df2ec8403887234196d7d548819f4725935e4333ed9802d6bacae"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa1ba23f987df2ec8403887234196d7d548819f4725935e4333ed9802d6bacae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6830146fdaba73d2c0bd32cfd4de1fcd9f1c5d3b097acd6fa0d062ad81a3e5e5"
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

    system "go", "build", *std_go_args(ldflags: ldflags, output: "#{bin}/gdu-go"), "./cmd/gdu"
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
