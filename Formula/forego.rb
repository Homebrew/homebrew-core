class Forego < Formula
  desc "Foreman in Go for Procfile-based application management"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/20180216151118.tar.gz"
  sha256 "23119550cc0e45191495823aebe28b42291db6de89932442326340042359b43d"
  head "https://github.com/ddollar/forego.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16941f70aab7b9ff0fce10386a47a07893728397319f9cf8027e5c1b052319f9" => :high_sierra
    sha256 "5b7d4ce276f2e072caec1a5ca33b75d73623893ee1ded78f5853eee3c6ebccb4" => :sierra
    sha256 "122b23bc8bba14c4376f14e7094d9c1e0c8cbe1da2bfcfd9ca93abb8cc038666" => :el_capitan
    sha256 "0eb5516da23538f663c29fc3c0c487d85efc19a556c5d81eff4038723dc1019f" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ddollar/forego").install buildpath.children
    cd "src/github.com/ddollar/forego" do
      system "go", "build", "-o", bin/"forego", "-ldflags",
             "-X main.Version=#{version} -X main.allowUpdate=false"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo \"it works!\""
    assert_match "it works", shell_output("#{bin}/forego start")
  end
end
