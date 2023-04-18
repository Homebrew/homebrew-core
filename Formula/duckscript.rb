class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.17.tar.gz"
  sha256 "41f1599f0d97fe3278cc9cbe738ce5a2f73ea142968cee390296e44f51cd2265"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120d3c1a887bd007339d1ba9791ec8c72b07c0b3ecc0e947ab86ce28ec59bc63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c23605c4cf2ecaf085468458df6b9f6cd3574d885d7669ad2fe2eb9bccac4e2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3117c5eee1d805ceeed8348fe99587ab68133a8cf40735f10a8ea3d3ccf5f84"
    sha256 cellar: :any_skip_relocation, ventura:        "3aa2467aa3f916513c23a8bd35705030aad4c9f2becf824c814eadb832d645ac"
    sha256 cellar: :any_skip_relocation, monterey:       "6daebc3e65d414089fc3f0f239ebd10dbe8d3a7e8572c858af89257ff580145f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e940e73adaf7668788020218e0bac38444cf5ac9803ef277070486bdfc79dba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f4eb4410585340f5a37b9a909a3fda44c7d29739e49db3fbfb881b18664fc0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "tls-native", *std_cargo_args(path: "duckscript_cli")
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
