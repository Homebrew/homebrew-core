class Forego < Formula
  desc "Foreman in Go"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/v0.16.1.tar.gz"
  sha256 "d4c8305262ac18c7e51d9d8028827f83b37fb3f9373d304686d084d68033ac6d"

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
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ddollar/"
    ln_sf buildpath, buildpath/"src/github.com/ddollar/forego"

    ldflags = "-X main.Version=#{version} -X main.allowUpdate=false"
    system "godep", "go", "build", "-ldflags", ldflags, "-o", bin/"forego"
  end

  test do
    (testpath/"Procfile").write "web: echo \"it works!\""
    assert_match "it works", shell_output("#{bin}/forego start")
  end
end
