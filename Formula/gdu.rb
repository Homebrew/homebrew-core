class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.7.0.tar.gz"
  sha256 "d199a71780c4ee7c88323c054a450ec510f2fa4d36667971dbd7409192ee690b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d91d36d764a608ebf994a623e716c5d55a31b507424028d810e40c4c18ff0ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "780421d05f8b84d4d7bc8734f2760e264d213eb3988b57daa3832df9c9e7bd5b"
    sha256 cellar: :any_skip_relocation, catalina:      "b28cd7f66c19e09244d37a68c79277b05e5c5af333066c47dc6b39de085db2af"
    sha256 cellar: :any_skip_relocation, mojave:        "72c0898eb316be7a9b839fc33438ff6c50d240f2fd1032468df91b3842301416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "116c79a59061a141b60def54121021bc704c09a7e04c46e6ae763e4c4fa006d3"
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
    ].join(" ")

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
