class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.27.0.tar.gz"
  sha256 "ea337207adea2860445f8a4b50a05045fd0a9055236e91a3e70c3462fc9e199f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e34f4a550a3fc13a9d055024603c8b1ecb45454e0e3745c9c0f4df011f7186b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d52a55b4d095f2cf16b0b214bcf7f5aa92b999283c01b9cb6fe474cd105537f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbe9a4b68f83a8f3c453caec7e2f74634af1415563d1c8daf877a06972d2d57b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ad4e12916b110339d06d62ee573fcdf43a32fa43e91dadb691a0730bfbb5a72"
    sha256 cellar: :any_skip_relocation, ventura:        "8f57333ba374fff682920396c3006d8d5b9a1c38e64ba2a249da37120de634e4"
    sha256 cellar: :any_skip_relocation, monterey:       "e1fdb4b15915a23a164a3d5daf2373af6693b4c04c820be281fd784967558ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e688f2fb2cbf6100b778cc687cabe016edff7c991bfb4263d49be484738fd8ee"
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
