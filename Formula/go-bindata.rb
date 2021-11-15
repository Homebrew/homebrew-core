class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.22.0.tar.gz"
  sha256 "1ad4c1e8db221aadd53c69d4cb4e3ebfeae203ecc61f40dfd4679c2b0d23a932"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5810dfd48a08d965a3587f6cba49538bea3aa5e5858c817a42d9e3aeade89691"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a01ea5516d7864ae98529fc766cbefc5ebdbca00331f534fc43b084a214fc967"
    sha256 cellar: :any_skip_relocation, monterey:       "7370d9f38fe852ab22ef7eec86c1c2ce5e174e6d7869b201b5f1f133003e624f"
    sha256 cellar: :any_skip_relocation, big_sur:        "189c89dc1cc88cc5da16f0d9d9bcf21cc8e13ff7623db34e59c8bca73a1ead34"
    sha256 cellar: :any_skip_relocation, catalina:       "43ea329d2cf2f21b1f0829d0e651755cdc89c313729304219376796a0332bd55"
    sha256 cellar: :any_skip_relocation, mojave:         "5f8643d57a4de7d2925dd66b0949dfd634fdba6313f85d171ec34ebc69ededbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdd58e06e26c6a0d83d17f29b81cc54dd1177be42d00c303fc77c309ba791416"
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kevinburke").mkpath
    ln_s buildpath, buildpath/"src/github.com/kevinburke/go-bindata"
    system "go", "build", "-o", bin/"go-bindata", "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_predicate testpath/"data.go", :exist?
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end
