class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "3d69faf2e98f92df9984baf38bec02a88bf2db2113771e9567570d802d8fddde"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c2cee073ec7e09b14c715dde81c72ba176d041f60ef721c81e6788083656b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aabb4e1d7792e89f50c6ac1049f8d9984f8aea5c4ad47b56d12bda35b4558e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df24c58d16063eddef2c1e6af8360d0e3b5df42168dcc2426108cc9c73e23ed5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bed5bdfa87200ee99c685ca59ef0077c3985e7954e3302d6c247c542624a944"
    sha256 cellar: :any_skip_relocation, ventura:        "98ba1fd6f227103a14cf4be767ecc18109572493faf0061d6fa5d9c0f43051f8"
    sha256 cellar: :any_skip_relocation, monterey:       "afd981cd65eb398c427254eea515cfd57a8f974212df33f50ad8b7aaec854232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19f6e7ec7d2bc2d14ad146a12ff0b50e66dd629a64dfd66357f389599837051"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://upload.wikimedia.org/wikipedia/commons/c/c2/GitHub_Invertocat_Logo.svg"
  end
end
