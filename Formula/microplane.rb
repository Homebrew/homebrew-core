class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.26.tar.gz"
  sha256 "00d6abe55fedd7385f1782fc97a520c4c0aac1ff6d2cece88fc7a21c2c49f024"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd71709815772fbf94f434f77f7426ce0544d2343471cfe7d9c71fd3e7e9567a" => :big_sur
    sha256 "338b41245377f99989cc7ac786af29c075d7bec8764cedcb176fb21b9beb4ed7" => :catalina
    sha256 "9adc70ddbc6fa4e70e1b006d33222de211caa09d58773e70d449e974482ddfc5" => :mojave
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
