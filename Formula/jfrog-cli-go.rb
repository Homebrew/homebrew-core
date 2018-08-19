class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.19.0.tar.gz"
  sha256 "11221ec29d7cd82bd60e336f386f4a95816514d19e825dfac4b11caa57b298e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e297bc5e744c03795cbc5a7703562d94ed69a53984fe55e183b94bb105bba871" => :high_sierra
    sha256 "92a6b644f28388a86732cbf00f41e46413874d648dac4f9b7607483f9dfe79a0" => :sierra
    sha256 "901ca9250763fe48ce47ae2cf2e9529e232e123d7f4f8f745226f0019b6c8453" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
