class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/39.0.0.tar.gz"
  sha256 "59c97d2188c2db3fc17ea90679fe9f7e7a79dd0e416f724a5104ef06ba84e9e8"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f91ed6da8e3229f71e0099ff7a716bb7202ae8286641331dd810255478ef2d51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70f8a77c1b2bc1a901e25e2f1af1f49d8f5f497b7e829c3123d4cda8dced4351"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baebe67923a6a13bf901f8226fd7a4469652aecf5284a400ee1a158f8e6bf303"
    sha256 cellar: :any_skip_relocation, sonoma:         "643206e36d62ee5662b889cc531d19c65e1ea59c5da5fb2e9dbcd5cdbcebbffc"
    sha256 cellar: :any_skip_relocation, ventura:        "0325233f06a23b8846c0d2a7a3f3b6db7131c7d2f11e182480b837f3e13490d6"
    sha256 cellar: :any_skip_relocation, monterey:       "fecb46b6da7f7184235dc2d4fed586f8bf200dda2db68d519d3f10047932af1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99746479ae03206a3c8e36ecf34d2be771c2917b55eb69f1bbd5b3a1575e8cdd"
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
