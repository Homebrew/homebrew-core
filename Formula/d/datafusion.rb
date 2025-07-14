class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/datafusion/archive/refs/tags/48.0.1.tar.gz"
  sha256 "e49a30bb99b11cf80889a47e0c0a836dd130260ec3f7cba739941bc34ab05344"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e8416896856080425e2ab65d0a9d1ac2cd290d4034a42e5896e1c1c172b994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a90492bf3377101480a79d4b1c71b38ae787393dd2116100d64714e57c0d655e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19aeb3d20b6a6f1b5e5c42bbadfff81aab9c14dae96bec5dfd8671fc26a38bac"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4526c5f2303434eb04d9e5b965dfa3b911364987f13debc5302412758170feb"
    sha256 cellar: :any_skip_relocation, ventura:       "0684e9becacb7faf997c924db4d3c8ee57cb4a68938a49c0b54313b39aa09211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "815ce356ead9118229343fb69360fea5b85c3feae993eb54f24eda01062754ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ee417e57d247d6a8a4bd56e514b401c8dd8cb4bc14328dba54ea04bf315ae9"
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
