class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "b13e1eb77e1fa39353365a5d1118e945a8a180dbfd0469eaefac65fe252ffa53"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8154d070db85b02a165a5f4f8942a4a54da2bcd0a96e02110d0401c979ef59d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1214630ba7f3329bbcd4b3579ce083c0419fba5562592fbdb8344051c4bb2d7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f22bb016ea60b69bd3d90ca26b3ec70f8a777e9dbe40565a7ed544308b5c56c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c8e470f3c4d07b6a8985e296d8cc758c38b2d61dd5b8e0a9736c804eb57561f"
    sha256 cellar: :any_skip_relocation, ventura:        "0ed1f93d5f527f2c3fe5b6588e18b26bab6468fe006d5758a156576c164842f8"
    sha256 cellar: :any_skip_relocation, monterey:       "07f527f68ce4d53b5edaaab91015b9aff86350d0edf70f6dc099a4f30048b238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cafdc21206d036e106c3d9f33f9266cdf3b9622f177e777cd07bddd88fed83d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

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
