class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/gopls/v0.6.2.tar.gz"
  sha256 "5103ccf16200000f92d1024cd662c589c7cae20955c9275234a10e942eff455a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:gopls%2F)?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a4f60e4c2e8a70aae414995319bb6b4dc5dfe4295a5d105fe0b0fcf84a02f5a9" => :big_sur
    sha256 "38711952665cce5d9e6bf606c6ad08dba09f7ebef09f84ea6a35fb2a0a248b4c" => :arm64_big_sur
    sha256 "a4d25c188943c90cd324b052cd43ab4560328051249f4be410dc9c5903e5b8c7" => :catalina
    sha256 "1d79c7f315bf4e0737036293faf6c70af25d7162c463e0969915bf5c8d08d12c" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.generate", output["Commands"][0]["Command"]
    assert_equal "false", output["Options"]["Debugging"][0]["Default"]
  end
end
