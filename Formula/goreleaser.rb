class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.151.2",
      revision: "ea83297e735fc0c677b3de1b7875f0d35f26fa95"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dad79bde6fcc2952daa5d5a48d840120879c3d41d7ee6b348ae822e1cba83472" => :big_sur
    sha256 "5d1b0932f07bca532e3f89f96296c4b024230f94c5e4b9fcbafe991590005299" => :arm64_big_sur
    sha256 "c05e8da060cb2c623c2447296d1be622236bdc15f92bc93602d8ac7627a33312" => :catalina
    sha256 "a99c20d0090a420429063a00877c3816021e497e9ba169cba183a725a6e6034e" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
