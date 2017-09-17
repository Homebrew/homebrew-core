class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.10.tar.gz"
  sha256 "1b053abd3f8c3b436712597e5dc7ce44c71737bdc0016cbf773a4e74c712851a"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ad9283fa4744c6ff86279545d4e1862f4c0300915da129a0a0b9cc9dbaf0a84" => :high_sierra
    sha256 "521e2d86a51100b0095e98a7b0d0fa06f86456df3963703032f33ecd904eec49" => :sierra
    sha256 "b93f6ed3d00c05954a23bf0615adf9136a7176e67ea754d740ac2573203670a4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-o", bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
