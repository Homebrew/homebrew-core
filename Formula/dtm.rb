class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "b33975ad02409da5dbd0615291803e3cd7ad03be26280522249fdbccf4f4ebd8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb335bb00cd1b692ad8732e77a082a0b6e924b1ae5f72919f60e4b58cf587d06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b945eb0751fc1e064a4f8e9eaed8df4d02b99edd1a95c2db7fc2951c3e6ae50d"
    sha256 cellar: :any_skip_relocation, monterey:       "b88d060d0c2f187a5b81f0869d2acde9a05ee303be7868d8c7f70c395e1fa933"
    sha256 cellar: :any_skip_relocation, big_sur:        "663b42a158c6718c1030c5b87edc209a8a22a590174ca20b02371dd6cee7453e"
    sha256 cellar: :any_skip_relocation, catalina:       "02f6cfdeb43b18be8aa82315344ec736d038973e82602ddcb585290c026491f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20da2260823e21e108ac75a0e2e73b3ffbfc31364de1ce548fdc86568235e31b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")
    dtm_pid = fork do
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    assert_match "succeed", shell_output("#{bin}/dtm-qs 2>&1")
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
