class Hq < Formula
  desc "Jq, but for HTML"
  homepage "https://github.com/orf/html-query"
  url "https://github.com/orf/html-query/archive/refs/tags/html-query-v1.2.2.tar.gz"
  sha256 "0fdc12100c178cd2e5ae61c54e640ecb68533017fcee4845ceb4050d1e4fff60"
  license "MIT"

  livecheck do
    url :stable
    regex(/^html-query[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cc649ddcba40f11b96eb1ad1589f4aa507f4df907c67a249cceb9837f068dfe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "98303f1643d1cae4cd2c7c12b89eca81e9861cb85a3ff9259b7e91e21cdc81e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb2ff0f3f904b95e1de83afa9df496e1cdb9e7b884f8bc6d6752e1d4f2e5add2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb0f1f15deae5619464b105b1fb9ac5c3086e9d74146d8d41155390f48a4eac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c09153ae3ec35218ea7b371ecc89404e391eefa4b8e1510f7aa7ec98b3a0b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "96168009af37277c094136a7fdfab3de012ffcfe9758becb2ab885279c3cbdfb"
    sha256 cellar: :any_skip_relocation, ventura:        "1fc6b120bfea15968b556c36a75428a9c5f7df760b73c94e5eff5fc77cc3e714"
    sha256 cellar: :any_skip_relocation, monterey:       "39119277ab30f7b0f5b5c60905cbe36764eb5aec06ec7b9d6ad1c780afa0cb9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "85a77b0126bc74d1645877c96fda56a2132373d0ec5d32488c8206d2e0367e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e9c85bd5a5304f6be3adb3ea8b0b69659f1622fc873dfae7b7fdfbaaee8ed2"
  end

  depends_on "rust" => :build

  conflicts_with "proxygen", because: "both install `hq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "html-query")
  end

  test do
    html = testpath/"test.html"
    html.write <<~EOS
      <p class="foo">Test</p>
    EOS
    output = shell_output("#{bin}/hq '{foo: .foo}' test.html")
    assert_match '{"foo":"Test"}', output
  end
end
