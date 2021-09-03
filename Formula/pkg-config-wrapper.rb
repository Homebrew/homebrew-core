class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/v0.2.8.tar.gz"
  sha256 "9d3f3bbcac7c787f6e8846e70172d06bd4d7394b4bcd0b8572fe2f1d03edc11b"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  depends_on "go" => :build
  depends_on "pkg-config"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output(bin/"pkg-config-wrapper 2>&1", 1)
  end
end
