class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-53.0.0/apache-datafusion-53.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-53.0.0/apache-datafusion-53.0.0.tar.gz"
  sha256 "f2bcdec8d820c6668427921b99007343ec47d61d628c9c677eba464133eb3528"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6149c1deeedd247c331b30b2c69d78a831285a7cf253bf8d8431826d9de9789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd584a8ecdfd24b6ee7d543caf5937d48015133284521d9ad9f974e5de86aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3954abb4fa06d39e85a6514621157ca4a12f4dc634071fe9ee4a6f3820a67d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a844598f3d4a62826452ed16f03a9562cb9df99aafd17d26837278fa340ad12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcd05873aaad1d5414961f7e3263b00ac3fcc53de9fe80e6f157c203e5de3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47616973d2618798160d6ed6e38906e2fa904745eb1d6a4a6416503d9747439f"
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
