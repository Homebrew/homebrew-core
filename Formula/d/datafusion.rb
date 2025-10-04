class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/datafusion/archive/refs/tags/50.1.0.tar.gz"
  sha256 "5fbe83e3dafe66e06a004cb15ccf70e9ca07bb5f02fb73e264e6532587e57a7d"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f1dbdd89089220698b4320ee792dc4e78fc0f59ac238bf1b66946aefcca34f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3ffb1fbab5d0f044b0b0b8b118a5ace0e79713f01cdaf53af93adc2a76174ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e03c3717495dafd62e9b2ee4ff2388709d2bfd3ad36c1c21e1a249db72219ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "44ba44b362291b1cea4ea5bccc79286a125fe617682b99d1e596759da645c690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "316eea80050c4c146a7cddb3243b9c051871a9e6f2935aec94a9de9432a84a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "898591a6b40a91ad9f6c8fdc48a17ff32d74971173d2268f76ed6560438646b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
