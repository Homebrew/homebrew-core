class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "b8ccf2b86c815693af1c7d743ca711a68fcdde94d9a9279ac8557fdffa3f2fc8"
  license "MIT"

  depends_on "go" => :build

  resource "testdata" do
    url "https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./csvtk"
  end

  test do
    resource("testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end
