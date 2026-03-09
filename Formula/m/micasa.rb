class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.77.0.tar.gz"
  sha256 "aac2d3252a2d8f5ac4acb9d7fb798f944dd416cc5cd4b7ed89a3f5dbe70567a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11cfa2ceb11540a54d1c36ddf269b8a6e56d4895b6352ace58c9732501905cc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11cfa2ceb11540a54d1c36ddf269b8a6e56d4895b6352ace58c9732501905cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11cfa2ceb11540a54d1c36ddf269b8a6e56d4895b6352ace58c9732501905cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "98f11759f60f5c3a151f882093da58145108818e1f1fd8ba2ed9510b32132840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "470f23f65c261df660a506f4d376e3df6ec6e469577f072c9f3cb778db734cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2f3c06071acbda89c7595b027f7c378b3b1f929c11ba26a682470d54a27e0de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
