class Fileql < Formula
  desc "Run SQL-like query on local files instead of database files using the GitQL SDK"
  homepage "https://github.com/AmrDeveloper/FileQL"
  url "https://github.com/AmrDeveloper/FileQL/archive/refs/tags/0.9.0.tar.gz"
  sha256 "34a749bdc8c3346d386b817af6c4786a56b99ce39e8cb699f2c02c4863e397e7"
  license "MIT"
  head "https://github.com/AmrDeveloper/FileQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5eb8d9177e0f0777a7dd183be3ec4a20a20621ab8b26898c62859902fce2f19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26ce2e997cdbc92088b542d1486b4c75981b976604ab88afde694ee4ab940393"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16996653b04cc26692f3c2943c437f7423c738a9a37b6e8bc0af43e7c5ce6e1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9489d0febff0359a5fa7638cb0797abf5ff63b2dc8cdd301a136ca6160986cbc"
    sha256 cellar: :any_skip_relocation, ventura:       "53f2fd9e804e440c14534788165a06cb2d67e52374273b8e0d9bc97cbda45582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce043761b6076eae3b5794f8fad52ba35954f2e2231731aead47018dd8e2d6b2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = JSON.parse(shell_output("#{bin}/fileql -o json -q 'SELECT (1 * 2) AS result'"))
    assert_equal "2", output.first["result"]
  end
end
