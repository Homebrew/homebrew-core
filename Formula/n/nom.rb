class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "b462d343e81f1382f38a9bd829be38f6b89ed2457f7bdbac2f8849078b9b094d"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6606809ac89b4bff1f4811f26fa0ce0553bd030f13bb13692119587a13afa0fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "657437e8944d5ab1a2c7d5139d4704ca8ca678e27e1c72e101f68cdc77c1ad0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76669832db3be14724d7e1b33ea6bc048bfa7410843cd277c8ace7cd6d9ef93d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c93a832f8cf5a33b738388076ff17ebc802979b7e3224b392afeae6a098153cc"
    sha256 cellar: :any,                 arm64_linux:   "5253dd715423a5e17eb095fa08ceba10a3b2fadf4e1b50d9f3b3de98a7063cca"
    sha256 cellar: :any,                 x86_64_linux:  "7c416ae3f203503aac0d3beb258cbbfbad4ef0d4787cdfa22af106f0d6e5f054"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
