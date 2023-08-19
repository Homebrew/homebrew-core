class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/29.0.0.tar.gz"
  sha256 "25d72eb31c4e655f0fb21de8b7acfd2fd3d01046865973e0c6f3b9f5a816126a"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2178416b8b8e6e46f77129a4b15b002d947967d60921e7e1b94f3d50fed2304"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a77062ded6ea4951fcd4f0ab34d0d6c73e1143027aaae127c188a7287cea1ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf7e69655dc902e742ebe7d5915c25706d8b4b738671ae19a24ef67a77f88be6"
    sha256 cellar: :any_skip_relocation, ventura:        "66ce8037b3f901f70d87d71110b81d2621ad3df097d9e4053c605bf1d112a861"
    sha256 cellar: :any_skip_relocation, monterey:       "91e4711808a83b8b6b6a367229e404c68eb83328e0d30c92053facb0413e2627"
    sha256 cellar: :any_skip_relocation, big_sur:        "e742bcec1425952f885bfe9ecaf7daa6bd6d46ff3602d8887609acfec5545840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d84cee8d98851f7863cad9681d4384304dea283a5b76351ef2750d546b94c9d"
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
