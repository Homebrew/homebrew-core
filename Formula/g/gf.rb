class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.9.8.tar.gz"
  sha256 "1b3d28dd8bff2821d87d66ffa84fd3c8c4970148f53e9bc3c9c04899f8cba88a"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0128dccead33539d340b3ef1c80eba116f2f007da959af7381982afe6728f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0128dccead33539d340b3ef1c80eba116f2f007da959af7381982afe6728f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0128dccead33539d340b3ef1c80eba116f2f007da959af7381982afe6728f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "f45b54fdf6ac485d95cf6600ebb49dc6306b35f51b51910d67c181fcc0d28582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc3e14a5f0155edf0e9ba3b5b7fcac7e98bb1b10d4015d121fa2ec548577200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e40a385fd224ac0066726645b0014a9b6e0530727e6314100ad027ba1f90071"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
