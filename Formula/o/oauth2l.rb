class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "a27f643949baa9f057bceb490c170d589728d3bda0a3066f57e17bb02b383cd9"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879e5bfdd9fa0af54da369fa085e549dfff5416dd09be7415e34e3d0bda8b7a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4410571958fb9512c71c88460b8c5ce402fd02885e6f157422ca133598dc4fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4410571958fb9512c71c88460b8c5ce402fd02885e6f157422ca133598dc4fbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4410571958fb9512c71c88460b8c5ce402fd02885e6f157422ca133598dc4fbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad00aec35684048304e9840cf3e9353045d127684d94462bf3fdeec803ba1a0"
    sha256 cellar: :any_skip_relocation, ventura:       "5ad00aec35684048304e9840cf3e9353045d127684d94462bf3fdeec803ba1a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "446f2ea6782b001238cf497d81915460915841527e853e1ffdb22cdd506822e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0efdf0d0bcb9385726a0a090a0e576e1cd91efca08eede002743787eff1d4af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Invalid Value", shell_output("#{bin}/oauth2l info abcd1234")
  end
end
