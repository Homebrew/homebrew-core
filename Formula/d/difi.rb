class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "1bfe57f791cb8436122e84f5cc4cd786e2e2c453345b0b92a94b50054cf51af4"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81461cb2214ec4d669c95eacc17ae4dd54d84aab4c76e7a5bca275338d56a3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81461cb2214ec4d669c95eacc17ae4dd54d84aab4c76e7a5bca275338d56a3ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81461cb2214ec4d669c95eacc17ae4dd54d84aab4c76e7a5bca275338d56a3ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3d840679ec1f7fe869f788c0e55d245e19844c05def7a10175cd63834b5c082"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4be6e4fa220df08418cce01754037187529aa2a98c9bbc3c00001c780e9d1e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b51ef53df206b003f1b94fc0812b1e1ae7383a4b1399190a52bbff57d9f2095e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end
