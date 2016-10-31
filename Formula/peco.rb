class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.4.5.tar.gz"
  sha256 "d8efdc807a313962780026ca20a428d3d04ac543b83ad6486eeb475f25113434"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b3996588e42639759334721c29389c3fb12448a14ac6929b7b6249e1890a9cc" => :sierra
    sha256 "4ae723c8405dbdb88391a56729cf76a33ac7e79b0853540ed91808974f5fba5a" => :el_capitan
    sha256 "184d7192674395dbf5bcbb4079dd6e7e9c32d30ac972bb0de4d30c2a4392a481" => :yosemite
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
