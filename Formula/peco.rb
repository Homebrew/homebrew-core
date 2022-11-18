class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "781c2effc4f6a58d9ff96fb0fc8b0fba3aab56a91a34933d68c5de3aea5fe3f6"
  license "MIT"
  head "https://github.com/peco/peco.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9bb5962a6e296e3ba31ca962492d3fe97ab0aec3edad9d9fa30edf688994609"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cbc798bdabf06a5f02668d1d3c53662aa416bc7bbb1d41a6cc3268ef7d563f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d272601e901b030d5912749e56d9c27bc08ea42a47833658f5d0ceef3b3acf16"
    sha256 cellar: :any_skip_relocation, ventura:        "1ff89f14740cfff07c4824837b115df6b92e30f9c88c1f456aab27c7e5242e3c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d86595f91d6fd84c240c57791e731b2e6552dc533d2cdf7c1421c06d1bd9b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd707346be0be24e7f91aeca1bb9520a17d9632758e427dde0b66c4638944be2"
    sha256 cellar: :any_skip_relocation, catalina:       "8c6e6459743f08e90e73f9b826505807b8d0d3f2ad2d818f580bcb2addf7c115"
    sha256 cellar: :any_skip_relocation, mojave:         "7abf9bc7b046f07d3f2c53599c2f41cac7196945cda79f10295db4e61aa50397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddca8855e36be24dbb661a5b306932f23fa3f29b6bbd831926d0548e025ba3c4"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    system "go", "build", *std_go_args, "cmd/peco/peco.go"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
