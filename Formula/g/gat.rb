class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "f325507877cae33dfa5afd96828eb22896576e1f11ec18624860892b1052626c"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    manifest_sha256 "7a6f0ebd40e9181059077bedbcb173ce47f345f7a8c5a801aeb63cd829db9961"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e781cc82f1d85f5e2ea8cf22813fdfcf7ce77934b340f78d8569b05902e0cd9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e781cc82f1d85f5e2ea8cf22813fdfcf7ce77934b340f78d8569b05902e0cd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e781cc82f1d85f5e2ea8cf22813fdfcf7ce77934b340f78d8569b05902e0cd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db01ab498a03a2e49bf7f98e2854e6b666e6a87d681fc80545dfa618e135b14d"
    sha256 cellar: :any,                 x86_64_linux:      "4ba726b669f75beb86275b502edca9f95923f6935281765885247d21dd9514ae"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/koki-develop/gat/cmd.version=v#{version}")
    generate_completions_from_executable(bin/"gat", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
