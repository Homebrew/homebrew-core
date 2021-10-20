class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.2.tar.gz"
  sha256 "6573e1301e178fe57f8d97fe7b299b9c0c1ea4cdf690d6d19aa9d20eeb3ab92a"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7b686f114911e2a65196bda34357bf5187c933fa5191ce7205b81f6737a37a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "40abf03574efccf2f579b38b8acee934a2c0e3069f2edd75d6483e1f9c02d6ad"
    sha256 cellar: :any_skip_relocation, catalina:      "e6246fe27379504613c5662eb08cbc36e4408101f9b6fb584e260a76b3388b42"
    sha256 cellar: :any_skip_relocation, mojave:        "249fecf7f9c0ba858a0065352a846e8a640b2a86ec605ae294de6f065ac8e31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d50a98929ff4408dc8e3b06644aad2ce1f88dcbf57daf8de167ecbe567c5a7"
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
