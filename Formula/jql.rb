class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v5.0.1.tar.gz"
  sha256 "c1074e2db2bb53da6e3786ac016039356638861a0875ee2c20feb894eb7e242b"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4358fe25087241a8c10dfaea37f04223f03c13ab5b253b79b2694381b5ff7cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7eeea21d627027af22369b632513f2145fe88d3e3b0fb4adfacd8fd98272d39c"
    sha256 cellar: :any_skip_relocation, monterey:       "642ea49683559d61320207891c5d3059ce8ae7dd9f9e3dd699958a23d747fb5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cbab3cb0b08871dae8a840153d941fbdf75c4210b070a303c8bc74f2f75f142"
    sha256 cellar: :any_skip_relocation, catalina:       "9de04398adf3d497e9829a5bc1144b9df5d983f42c6e294b100c5fab0c9f333e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f476e5e5d55c3f3a017184be27dacb7ee466b0ffa9959e1f20053110f7e10382"
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
