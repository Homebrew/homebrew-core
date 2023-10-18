class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "246f2863847f5b0e832e3ee02b11b17b756bcfbb024b4415ed3046f2e19ca119"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50efa2b9add2d7cdb94f4f60a53bfd636dcbe9c5836b894f366706050f0c6e2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "540270a8170e8276e1d786e0bf8277716028d03f7f51d21db6287cef39bdccc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af2ffaca801052749816fe00a383271e9479fabc3ba7ca6789a609351f51ab95"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ef81e0ca13d15a76195b5d8eb3bdef0b7e27ec83e98451a950f62312dcd45a2"
    sha256 cellar: :any_skip_relocation, ventura:        "c343caf22586b1c1f73a91331909f54f34c988a71369345f0d619805c04fb8cc"
    sha256 cellar: :any_skip_relocation, monterey:       "d0687a665edd2d53b39fce645789def0aaf9ee6395ae9aeb4c4c0c844e891ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ada6faf8cb600c81d74de809b8c58c5088fefacf0b3a4f5fc8e77352a7e142a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
