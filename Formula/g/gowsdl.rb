class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      tag:      "v0.5.0",
      revision: "51f3ef6c0e8f41ed1bdccce4c04e86b6769da313"
  license "MPL-2.0"
  head "https://github.com/hooklift/gowsdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "edb60eca3fd4b0d9c9bd17ac76d1830d0acb28b4cdd5bf85330ef6d2c0b14572"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b9720d824c3c5726f0efb61954537792efaf5ccaa1710fa9395053b89208dc82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff97f048a29ed347f7473201f2a5a94a36ed36a039b0f9ef523b781801e1a626"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aa45e1319557557ca74011ec372ffa4d404a3d4199d0b2c7ae78480b68cf266"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0391c1e4a9fdbd2f14d5daff2789d490802da3b4a09a227d021dcb1a58b2f92a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e00fdcd6cf4d9f6b4d8df22fbd7622ec946b4188944e4f5fb04aed3c29878f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "69a10be90d1bc0b93c2280ffd4a4db3613b21dc9d60b893f67b01d6364bb959b"
    sha256 cellar: :any_skip_relocation, ventura:        "03fd4af0ea805054cf29bc1156533b8540de308889d827459da3809f65cb6335"
    sha256 cellar: :any_skip_relocation, monterey:       "c810ea3ef7b3a12aeb84b71b71c0c67f6853857cd6fd778c65b9bb0b9fad157e"
    sha256 cellar: :any_skip_relocation, big_sur:        "311386c63c7c7ffda0e89c0cf753b5ce53745909e492b2866f75c157c97e48a8"
    sha256 cellar: :any_skip_relocation, catalina:       "5decccb2c1f5b9c093dc045fceede062ea21bfb0273c7cfa9d7c1cde04229e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8579b7b07203ffa43d65de8bd48ba205dca277d0e6057c0eba5f0851a2484b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f90850655453570875a7087b0ac6a850d059a68afba01b62a5e30e6aa7cfecc"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "build/gowsdl"
  end

  test do
    system bin/"gowsdl"
  end
end
