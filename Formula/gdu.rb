class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v3.0.0.tar.gz"
  sha256 "9a1d14662a76265faab369a2a2bbe47429405bd8dee1d096d75822a1b27e1b15"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc4c9da50185f14b57de86be129ec81b2be814e086f5b492026f9ab8f51b8551" => :big_sur
    sha256 "a9f9c285d26750b892b894060fbf4f6d74751ce34314c29b2730b39c7f79d717" => :arm64_big_sur
    sha256 "f6fb43e2c981ba04ca7d1a9f77da8ae34071da5dfdd9d056b014f7644f1011b9" => :catalina
    sha256 "d331cb29ff59a6ff7fc48a0a8787b7807b8b8b784f16a5fb4e620e2316bacb30" => :mojave
  end

  depends_on "go" => :build

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
