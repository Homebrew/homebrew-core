class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "e3b2833a983607140af9575ae82782565f7f089f7c75eae4bc4dca402824ea5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19c4b81eb2904e0e6552a9a8ee1a3c926fc8685511749d52813e14eb14d7b86a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c172223b401a06021be9b4c80f2ffa75732156a235ff34d54fc4e5f8c495f299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c5a7365ca1ea44b7bffa280d87aee8e982151cbf7707f81271e6d62c402994"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f2933fa45585718404249d04c18a19ffb66895e27459cc5a73922eaf12028af"
    sha256 cellar: :any_skip_relocation, ventura:        "54978a67871efb862860bd14dfa36b575ae1aa1a23149097daed6572d9484b68"
    sha256 cellar: :any_skip_relocation, monterey:       "c2f8b93cd4e8e324685850206e42d5e5e8665b46cb84bb98a792aa29cd8e693d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "710b3389f1dd78cb9ee15c3d6fc66f9c53f06944cb212042c7da824f33b4c1de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    touch "secure.txt"
    output = shell_output("#{bin}/cql-proxy -b secure.txt --bind 127.0.0.1 2>&1", 2)
    assert_match "unable to open", output
  end
end
