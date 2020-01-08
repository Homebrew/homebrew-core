class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.6.tar.gz"
  sha256 "f0d1eb271727d56fef18107532a5714083a1cce4f6e8fc1cb1681dcb6f95aceb"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb85a67b0efb4791324cf34b00a9006a20f939934d0992ed49a3c5e208d4eb39" => :catalina
    sha256 "84a8ffecb7b52a934e6c57a70ab073b46a13099dccf2fbf5b8a56b9eb5162aad" => :mojave
    sha256 "9b962800f1a3bd1ddb36692a5157059bfea38897259be46abcf8f144b5da1866" => :high_sierra
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
