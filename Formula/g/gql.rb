class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https://github.com/AmrDeveloper/GQL"
  url "https://github.com/AmrDeveloper/GQL/archive/refs/tags/0.28.0.tar.gz"
  sha256 "405a74d80149f1e05aa9bec9503c462aef8b47a33809267079eb1d3b4da33dfe"
  license "MIT"
  head "https://github.com/AmrDeveloper/GQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8eedca8b3bc5eeb386d14405cce1def7913d688e9325c50fc12daf48757fc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee294854a4ac87230ce38441e3f4b11b3e281bbcb9e79941e7ce68c3e32eb9f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c83725cff892f974b7c70056a648dca3cad1d27acda042bc746948d12ef9abfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa3cd77d5a940c910ed8468955ce270df043ee2a6918dd8ac0e108fd940412e0"
    sha256 cellar: :any_skip_relocation, ventura:       "57e2de748c238882dd90bbbf1d1d12e2cfa293045b53246cca052097d4997e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe7e65681c6d96cb5e7b501ffaec1dcaa09040f3b3071014f13aecfa4a66e5f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}/gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_1"]
  end
end
