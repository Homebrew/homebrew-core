class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.23.tar.gz"
  sha256 "0243aa58559b8a43f5fa7324eee05d490899aa73294737e47451d1fc994769f5"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "adfd90c4bbc09e44720f246cd719c508d7215b5ab6f9ad756c37018874e92dc4" => :catalina
    sha256 "2e5906f81eb7ad280b115c22cd2e88a28daf2b612bb7f35744ace27ab0d2dd9c" => :mojave
    sha256 "c5a414e1fa758fcb3d8b8a57b7edf3ea9174a7a71646d9a8e0f10dd2c07fb6ef" => :high_sierra
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
