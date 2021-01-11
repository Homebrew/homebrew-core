class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.26.tar.gz"
  sha256 "00d6abe55fedd7385f1782fc97a520c4c0aac1ff6d2cece88fc7a21c2c49f024"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd84d0aec16be620d405367c6afb6212fcd18495ccddbfc42594ea4cf14370a8" => :big_sur
    sha256 "f69c2809ab3d97ae84dc78a8bea4b2f32a7de47630136be624af358e67d2d6bb" => :catalina
    sha256 "5c03494a3311b7726cd8e894ef69b0d05e0208040c44e9598ab99e5f9b92858d" => :mojave
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/Clever/microplane"
    dir.install buildpath.children
    cd "src/github.com/Clever/microplane" do
      system "make", "install_deps"
      system "make", "build"
      bin.install "bin/mp"
    end
  end

  test do
    # mandatory env variable
    ENV["GITHUB_API_TOKEN"] = "test"
    # create repos.txt
    (testpath/"repos.txt").write <<~EOF
      hashicorp/terraform
    EOF
    # create mp/init.json
    shell_output("mp init -f #{testpath}/repos.txt")
    # test command
    output = shell_output("mp plan -b microplaning -m 'microplane fun' -r terraform -- sh echo 'hi' 2>&1")
    assert_match "planning", output
  end
end
