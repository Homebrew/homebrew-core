class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "f857d0a2bd97265a11b84a763f2589b7e8ee5964ee5876daa86791214ced000b"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6de8b2fb5f343afa172548fa221752099e11c1985536e5d16fd773d6cfc83dcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71b3b1a08a3b5a8eec772e0343822593899b44e893e6d895e8e9a452302582bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cdfb00741fa52302c0a0272b3e68f41b14b0086332ff48ef8b9bbf9d8f01263"
    sha256 cellar: :any_skip_relocation, sonoma:         "e681d96de291a5bff8de15d2f9481c52177d552d85b3488f308e1df3a423ce5c"
    sha256 cellar: :any_skip_relocation, ventura:        "6d367f61dda72bf82c10423471b95cb1bbdefa6364b4790974a818681f720f03"
    sha256 cellar: :any_skip_relocation, monterey:       "a373b5c54d1f3949aaf09c99e644f9bfb9f581011748fc708e84b07671fe831a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cb30a3860ea21c8dfb3030f413102c60570a465c664f750587e88272924119f"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    # Assert conduit version
    assert_match(version.to_s, shell_output("#{bin}/conduit -version"))

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = fork do
        # Run conduit with random free ports for gRPC and HTTP servers
        exec bin/"conduit", "--grpc.address", ":0",
                            "--http.address", ":0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc server started", (testpath/"output.txt").read
    assert_match "http server started", (testpath/"output.txt").read
  end
end
