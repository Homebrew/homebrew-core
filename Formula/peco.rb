class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.0.tar.gz"
  sha256 "079a7e1df392b2dd3dedcdca2de7e661c84ff0ae7c262c37393a1704d571b058"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da4e85bbd2a680bd5c9e6ec9dcf5e6ac57dd4ef0283ab044b9812cdfdf12634e" => :sierra
    sha256 "219bbb72e97aa11f03bb2285b162438cfe3e49b461b14b3a3f8c027e066a561a" => :el_capitan
    sha256 "7998b3abc7d9c6e4932649d8d2c00c56ec2a3b4909ecfa9ff513c739a27ff643" => :yosemite
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
