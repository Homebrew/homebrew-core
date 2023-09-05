class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "446e1a9afe0b7337cc6016bfd7e67e44d28b9f1b7942d8abb18e6ec5a31722ab"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b76e17cfad3144d7514d17eb3e3489b3e0c097c11c0a3adf28dc546f20a402ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "251b97c4f67e136f1ed32c7e963a82e913b70f48eb65da561bb20030743d3bcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9e835f3c5fa2856ecdec1a44e9e363691cc599c5880212b8f43a43ada102c49"
    sha256 cellar: :any_skip_relocation, ventura:        "91065d609e72266388b87305c469d9a9dc340e7a3744ff5b213eae55f2aa1e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "605f633d5f88ed1fce63385b0b0728a01a4a284f41305e1b161d25b4b600b093"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c181244a810c6575b604d1c5e42367a730af18e9e92cabad4ad3344c59d3b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56111877614bfe093e3b5ab87ff4666b8696ad639872fd499f901b6a9e767508"
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
