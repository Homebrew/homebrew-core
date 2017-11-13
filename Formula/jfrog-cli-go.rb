class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.12.1.tar.gz"
  sha256 "f3d537be1f680fe1701f9abf2adce4b490989f560000cb9aa7feb99d38e4e0f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e7361475cebfaba86f981251d3c33004b4466e5ebfdcb0491ed5a3c09d05232" => :high_sierra
    sha256 "69686c6b4b68cdeba7fb841425afb22ce451e5ba57f8a695f7653d022f473d2f" => :sierra
    sha256 "86dd6960c2322a8e1f9b610c47e51d0534f392b585ac209e200f9bec977dbf5c" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
