class Govulncheck < Formula
  desc "Database client and tools for the Go vulnerability database"
  homepage "https://github.com/golang/vuln"
  url "https://github.com/golang/vuln/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "9609756c03d8ce810a1a65434ad15d35213cf97414341644777308ae9753370e"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "241264db9449a92aee067de28f0e3f29d20fc1bcbf33f8d7f87ba088885542e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45cacfa3490e92ae8db85cbae1eb85d5d2242264ef18299c96f69c33b09ba769"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45cacfa3490e92ae8db85cbae1eb85d5d2242264ef18299c96f69c33b09ba769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45cacfa3490e92ae8db85cbae1eb85d5d2242264ef18299c96f69c33b09ba769"
    sha256 cellar: :any_skip_relocation, sonoma:         "bad51736276a2a11ceecff012ac9b1294309cdb4aa28228a416d3d61811599f9"
    sha256 cellar: :any_skip_relocation, ventura:        "bad51736276a2a11ceecff012ac9b1294309cdb4aa28228a416d3d61811599f9"
    sha256 cellar: :any_skip_relocation, monterey:       "bad51736276a2a11ceecff012ac9b1294309cdb4aa28228a416d3d61811599f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa83918d5c88c5f171e209d3b3edf61e55150dcb7e2350784e37688ea036fcd"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/govulncheck"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        func main() {}
      EOS

      output = shell_output("#{bin}/govulncheck ./...")
      assert_match "No vulnerabilities found.", output
    end
  end
end
