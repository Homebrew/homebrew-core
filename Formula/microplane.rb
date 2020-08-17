class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.23.tar.gz"
  sha256 "0243aa58559b8a43f5fa7324eee05d490899aa73294737e47451d1fc994769f5"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc7adc32dab526a8ed533e538e5e05b6059a140e0c532ee4ee5919a5917f67f" => :catalina
    sha256 "ac2f6857f4c4d3d70d711c6091bd0df94a5badbd0ce9ef4d9ac40be7c3a8ea27" => :mojave
    sha256 "8516eb9a47799cfe06ec4aa13d25a4d9b20aecafbe78bf6adf6d9f826d68cf2c" => :high_sierra
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
