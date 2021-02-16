class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.6.2.tar.gz"
  sha256 "fa53f872af61ecb2b5183c972f8aeae2fcdb01e888d9f46fcae07f78d8991d41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d4492b069e4be485513ac31103daaf9599ae781507364ecf4a671e5b1eb1631"
    sha256 cellar: :any_skip_relocation, big_sur:       "aeaf4ad8f0526cf11c0c5c9880305916135ff2fd289892d28821f414f36d6f74"
    sha256 cellar: :any_skip_relocation, catalina:      "5313c8ea28de72c1068cf8962168d1962444986ae51c67ac207cf5ad6b28c7e9"
    sha256 cellar: :any_skip_relocation, mojave:        "ec3e1de513367641ed4df03a1aa29cf3f969d3760e0c5a5dd39f3c1a3e22a2c0"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/build.Time=#{time}'
      -X 'github.com/dundee/gdu/build.User=#{user}'
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
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
