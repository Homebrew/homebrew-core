class Forego < Formula
  desc "Foreman in Go"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/v0.16.1.tar.gz"
  sha256 "d4c8305262ac18c7e51d9d8028827f83b37fb3f9373d304686d084d68033ac6d"

  head "https://github.com/ddollar/forego.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "43023b8d7dced63e30b15df1381d08ea0c3da8dada801c1e74ad733785333ec1" => :el_capitan
    sha256 "b5250bbca85972af704278f539b5b95fe0b2f1f17e3174299353ad79e8955e02" => :yosemite
    sha256 "39be1155c04fe129cc63c3b131ba4e302daaf09cf6faa76c79461f2c75d7c725" => :mavericks
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
