class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.6.tar.gz"
  sha256 "f0d1eb271727d56fef18107532a5714083a1cce4f6e8fc1cb1681dcb6f95aceb"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae7ead7012d642b886c3afe0614fdb82a5a2e71b5eaafaa1fce9dfc3f47a6ec3" => :catalina
    sha256 "e605993ea5cbeae13cb86ef63412ffb766dbd566a5e8dc16c74506e343db8ff1" => :mojave
    sha256 "f1559339b3f8e8e965a2b0da940dab2fa216c3135f7095f50ec85a0e6af4627c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/peco/peco").install buildpath.children
    cd "src/github.com/peco/peco" do
      system "make", "build"
      system "go", "build", "-o", bin/"peco", "cmd/peco/peco.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
