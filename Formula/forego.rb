class Forego < Formula
  desc "Foreman in Go for Procfile-based application management"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/20170327195458.tar.gz"
  sha256 "8a9bdff7f3d62ba64e9a8bb7fe619223e2fb20af6aff18f618ff2703a5bf1860"
  head "https://github.com/ddollar/forego.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a1415e14f065d016bd8bed47389d4728df6f914e9f43b596e0751047ccffd28a" => :sierra
    sha256 "db597e351270dd29d239af3e144c3e73ae588305267610365f218a9fbef784ee" => :el_capitan
    sha256 "75463485e3de109732c7b046f159a08c4b282fc2ea95ce7be2281b829726a3d7" => :yosemite
    sha256 "d60bb47949dfc148d0e6788c3389c392a479bbb6b1e17acad0ce45a1e90bbe6b" => :mavericks
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
