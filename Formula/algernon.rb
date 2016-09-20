class Algernon < Formula
  desc "HTTP/2 web server with built-in support for Lua and templates"
  homepage "http://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/v1.tar.gz"
  sha256 "048f76ced4bddc81bfb347e64ae6f47100c8ebb010188d258aa443a4f3a3b42c"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    sha256 "4957354f73c23db4a4076e13c3f8b9992f427287b3d674ca8421aa4a831241e6" => :el_capitan
    sha256 "88a91dcba9c888ed93cd2a5e3a9155a688bd467ea01c31a0e8647c65cba8b7bf" => :yosemite
    sha256 "189478d8da0f8c7746cbf457206a14736fc83ff0b63f6aebabda4c39ebc72fab" => :mavericks
  end

  depends_on "go" => :build
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyproto/algernon").install buildpath.children
    cd "src/github.com/xyproto/algernon" do
      system "go", "build", "-o", "algernon"

      bin.install "desktop/mdview"
      bin.install "algernon"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec *%W[#{bin}/algernon -s -q --httponly --boltdb my.db --addr :45678]
      end
      sleep(1)
      output = shell_output("curl -sIm3 -o- http://localhost:45678")
      assert_match /200 OK.*Server: Algernon/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end
