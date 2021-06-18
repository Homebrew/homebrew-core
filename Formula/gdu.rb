class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v5.1.0.tar.gz"
  sha256 "d51b1204f7d2132ef8d9d5dd20327630b6c9d8ab45d9f9c1c131334c73f28fe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c1bb073ba694200133eec22b7e8caea02c36cbc02850451b158b09224ccb3f7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d3a1fc4cd727289edd0fbb5ba63857c88314e747490b8481e1c10928922837a"
    sha256 cellar: :any_skip_relocation, catalina:      "375286e89b02a3126b57e3598da324bed92165c16f7df29bd3b4440480140f07"
    sha256 cellar: :any_skip_relocation, mojave:        "047919911280071e977dbdd540eab08de1450e0b2517b23fa5f0656cdca2fd78"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    ENV["TZ"] = "UTC"
    time = Time.at(ENV["SOURCE_DATE_EPOCH"].to_i)
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "github.com/dundee/gdu/v#{major}/cmd/gdu"
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
