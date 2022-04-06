class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.2.4.tar.gz"
  sha256 "360e3fc2d5a1cd7303f770ab5c46ba36ea2e708cc06f07bf42883c0d9eadc9ec"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1008dcba0962183c8c664fd9b0d749e539fc789094f55c73b98ce530357e66a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94522c1dc07da4005c6c5d7b5ce1a7117dd046b3612d9a6a8a4375ffe1a3bf82"
    sha256 cellar: :any_skip_relocation, monterey:       "65bc03245426442cdb1d16817358bb5a2939a06b92c0a4cc47d5e5d93dc565e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0224857d8f638d0b68d57ae2c09b68b612e2e7e6e3862a3fd6abc62fdb7abdce"
    sha256 cellar: :any_skip_relocation, catalina:       "924ee8c0fc347aec762711a543bbeea1cd46fcdd855cf30f0168a80e0c5fab61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2006fd6defdf010c9c53e73b6aedf8340061f93b22021cf3e377427604b488c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end
