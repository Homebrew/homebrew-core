class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.24.0.tar.gz"
  sha256 "95ce1cf37be26c05ff02c01d3052406fac2dca257b264adb306043a085a78be9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "393d24007da474bab10020541b98f9bcf1989c52478051a4d903338e5e7b3107"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6952b16dda6843de51bb41a9f5bff0fec2bddf88400198409f81af6c8cca6274"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a95685c849d1fc39a62ccaee0a066e4a47ae3a3bc2a5e158fed792b884215780"
    sha256 cellar: :any_skip_relocation, ventura:        "b60388a6048834d3f683cb3334c705ba659fd4a8aa39f1023c48ac75ef25462c"
    sha256 cellar: :any_skip_relocation, monterey:       "712a6e27f1326707d7ae06a470b78593c9d5db6aab5a456d2f9e91b4c88c58b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f06dcd463b954e6c84bc88914021db3390aec647cd872864f23818ac794a1853"
    sha256 cellar: :any_skip_relocation, catalina:       "2430d0f978aa8ad62d29a1ff93aaaaa0387ccd5a31a9a428f2fe1026e19132c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055ebe9f5971debf57a4e39666aca4ec4813b46d895651a294175e55a4c6d7cf"
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
