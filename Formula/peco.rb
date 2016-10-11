class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.3.tar.gz"
  sha256 "1f54da670c65b60575564913684ae7598e2d0cce26b5f539719d911ee121633c"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1456646cf2688f3472eb08dc012a7a349e511d4ebfbba8ed5540374f791595a" => :sierra
    sha256 "b584c0fe6eeed19324e7ae2c689413bddc358df6ead9cee1dd2abe81258c5ccc" => :el_capitan
    sha256 "d5d4e0de4ec8b3b38f58f816dca0b4c22d26f5a34fbe545788ab461aaf3cdbb4" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/peco/peco").install buildpath.children
    cd "src/github.com/peco/peco" do
      system "glide", "install"
      system "go", "build", "-o", bin/"peco", "cmd/peco/peco.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
