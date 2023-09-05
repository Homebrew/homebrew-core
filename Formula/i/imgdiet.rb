class Imgdiet < Formula
  desc "Optimize and resize images"
  homepage "https://git.sr.ht/~jamesponddotco/imgdiet-go"
  url "https://git.sr.ht/~jamesponddotco/imgdiet-go/archive/v0.1.1.tar.gz"
  sha256 "c503e03bb2b2bce9fce4bd71244af3ddec2ee920e31cfd7f1ca10da8ddf66784"
  license "MIT"
  head "https://git.sr.ht/~jamesponddotco/imgdiet-go", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de81fbb6f723124ee2339e1a5f52613bf0ae342164416e2418dfdda4541116b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d26edf95f2a68ba491d063e688030638984107da0d33c77b7a008d4b740a408b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70bd6552daa7f655a15723ec912abfd3e92cc206f2d1ebdc9d6bb32f4ed0e606"
    sha256 cellar: :any_skip_relocation, ventura:        "91e230a91073416afeec262e7a1f3db6d2db70d103dc7e67bec5d3677bc4e52a"
    sha256 cellar: :any_skip_relocation, monterey:       "29729d6900cf925b7abcdf373b367314a3bec84fe7b7132e51706ee948c94692"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7b37ab1f4ac867aa399cae59d41f0622d89ffb0869a08fb6298f5895e2ad3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5c60ff9ac8702d7a3e89e147a7674a764ef24ccc17bd2399101b170a7ac880"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "vips"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/imgdiet"
  end

  test do
    system bin/"imgdiet", "--compression", "9", test_fixtures("test.png"), testpath/"out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
