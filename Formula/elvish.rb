class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.9.tar.gz"
  sha256 "41aed14f500813c884a0a8b6c4ebbcdf233b2d139f1d10cea697d597007f1698"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb520877abb2b4b1d5be06f9bff519f8a5831775e70e04c838b7f2aee6f8cb69" => :sierra
    sha256 "c69a5b5b5c8a1967331e50bbc4b6aa4190da602e329656a29f38aef90a1d42d4" => :el_capitan
    sha256 "bc9758595a04995e5dd18061c97f4fa3b8975090735b97b7d546c95cb5b806e0" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-o", bin/"elvish"
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
