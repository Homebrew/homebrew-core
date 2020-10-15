class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.9.tar.gz"
  sha256 "5aee062c49ffba1e596713c0c32d88340360744f57619f95809d01c59bff071f"
  license "MIT"
  head "https://github.com/cortesi/devd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "26a21f49c1abdafb1be22d48bc4186c18c0ff53620cc60a35ac778ed22a46c5a" => :catalina
    sha256 "21b10d2ef5cdb6a11cb0fa64da6cb4ef5049d5bc9bc411ad4192127224709f2e" => :mojave
    sha256 "2cc541a0a844b83e60b89f79e1f296d391737fb635f1bd43ff5dd022a07dc67b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/cortesi/devd").install buildpath.children
    cd "src/github.com/cortesi/devd" do
      system "go", "build", "-o", bin/"devd", ".../cmd/devd"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"www/example.txt").write <<~EOS
      Hello World!
    EOS

    port = free_port
    fork { exec "#{bin}/devd", "--port=#{port}", "#{testpath}/www" }
    sleep 2

    output = shell_output("curl --silent 127.0.0.1:#{port}/example.txt")
    assert_equal "Hello World!\n", output
  end
end
