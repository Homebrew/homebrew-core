class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/36.0.1.tar.gz"
  sha256 "08500bd32233df480d661918dea186ce9a1d1e4b6b8988219c4707ac1854e7fa"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31c24acf77aa06df419b93a78b00f704897b00818759079af69f8abc47ddba67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73ca194f41c0693555c2ba1a42f6be93a5da68e76488fc9fdb47ac2be8d87edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754fe151c513e34ac9291ece2a3b5e3f4a48962a478e8713312c346ac5c984dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f64f06918c42d564ec5e137d5a2e8fcccf8795fdeafb45dc9e2cfa08bcaa05c"
    sha256 cellar: :any_skip_relocation, ventura:        "e89cc00dab942e8a4d863053f383cc1dfcd2800cc62a6debff9debed9de7148e"
    sha256 cellar: :any_skip_relocation, monterey:       "df7dfadacb83ca944fc3d59481b2bda8b5c71389d6a8281f9d794a74e2d0e26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca58d884acfa366256eee96e73fd67d9d91b004b7d1bfa6af56d518db521c6eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
