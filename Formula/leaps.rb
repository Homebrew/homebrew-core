class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag      => "v0.9.0",
      :revision => "89d8ab9e9130238e56a0df283edbcd1115ec9225"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cecda6732be6b32d1184038a5e1ad008c438053eabed0880c2f2ad194c4fefb" => :catalina
    sha256 "9e40e4b5b75c73411f6ab74bea028f72f25f8b788eadf032f0f5cfed03baefae" => :mojave
    sha256 "37343e978d4035fa9b2881c038748ec4704bf8a57308c59e64592dd404166e36" => :high_sierra
    sha256 "d269ec8f0e492e2a9c7804ca2cc6d9211a9be7c3dfbb0daaab19c5b14bef5b24" => :sierra
    sha256 "e36259af15ec8cf6546b1f7d99a105efb9a30c198f549a67964417e31892fe97" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jeffail/leaps").install buildpath.children
    cd "src/github.com/jeffail/leaps" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"leaps", "./cmd/leaps"
      prefix.install_metafiles
    end
  end

  test do
    port = ":#{free_port}"

    # Start the server in a fork
    leaps_pid = fork do
      exec "#{bin}/leaps", "-address", port
    end

    # Give the server some time to start serving
    sleep(1)

    # Check that the server is responding correctly
    assert_match "You are alone", shell_output("curl -o- http://localhost#{port}")
  ensure
    # Stop the server gracefully
    Process.kill("HUP", leaps_pid)
  end
end
