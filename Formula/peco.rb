class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.3.tar.gz"
  sha256 "1f54da670c65b60575564913684ae7598e2d0cce26b5f539719d911ee121633c"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "5f519f75eb49dc037ce22fc0a65c3304e0cbdf58e171359df9c5dd823cf45b15" => :sierra
    sha256 "d3e993c831c62cf75ba0f15285aaf2af4f09f89f68b262b0b5d28276888669df" => :el_capitan
    sha256 "b29c6d5e2039014db0daae5385611e479015a5ecfb3d49c9ad359b6c0e86be61" => :yosemite
    sha256 "29d22eaa232bc401ca8532f65f5267187b781a8210f338385439dc295fba8075" => :mavericks
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
