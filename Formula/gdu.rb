class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.3.2.tar.gz"
  sha256 "6d907c5b2e8e5f0392ad051274579c14288cf5f6c8faf7e08f774ed540c5fd20"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b7e8038e97807dd994992319ea573b38c9f5ee5eb5f3ed4df29b12187225afb" => :big_sur
    sha256 "3de708df81b016a2b618cb40034debd4f83f616d69a46d92370053dd56a58330" => :arm64_big_sur
    sha256 "1f5b1f633d0bd2629369534693bf5d26f8bdc0564909a2c7b33df51da7a622b3" => :catalina
    sha256 "45c1375a42dafcf3fbfedf8a70bf890f35d6344983059a35e52ae4dcbde51d28" => :mojave
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
    assert_match "5 B file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
