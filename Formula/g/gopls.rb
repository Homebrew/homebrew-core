class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.17.0.tar.gz"
  sha256 "0d362528c42d4110933515cbabd7c6383048eb279a0b74a6322883acbcc3a381"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916eaf4a20b76e569633455ef3596a0150217a63781ae7e0c4ba49fe36622d33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "916eaf4a20b76e569633455ef3596a0150217a63781ae7e0c4ba49fe36622d33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "916eaf4a20b76e569633455ef3596a0150217a63781ae7e0c4ba49fe36622d33"
    sha256 cellar: :any_skip_relocation, sonoma:        "42d42d64d951282fd5757703d6e1c1c026192a9cef6e4e808e8d58e94d7c2077"
    sha256 cellar: :any_skip_relocation, ventura:       "42d42d64d951282fd5757703d6e1c1c026192a9cef6e4e808e8d58e94d7c2077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2102b282639c0483e8fad930fe67e02ec168350004ad3dd99be93c36d5603b0"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}/gopls version")
  end
end
