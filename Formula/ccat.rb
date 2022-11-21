class Ccat < Formula
  desc "Like cat but displays content with syntax highlighting"
  homepage "https://github.com/owenthereal/ccat"
  url "https://github.com/owenthereal/ccat/archive/v1.1.0.tar.gz"
  sha256 "b02d2c8d573f5d73595657c7854c9019d3bd2d9e6361b66ce811937ffd2bfbe1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d047b4aededd042be8d667533534bfa4fdf3335051b8f88013659030ceecfa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8119ea94a08924e3ba9bdd1cc8cfd77afb85ca66d90ad58fce246e47afe6da9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2203ed8600403a7ebedf60ff3b1f7eac6bdd0793521d759c43f5a4c6ee0d0f42"
    sha256 cellar: :any_skip_relocation, ventura:        "d4bb45ec8cf50520f4f7199174f8881149e16c2720b1ec0feb6926c92306049a"
    sha256 cellar: :any_skip_relocation, monterey:       "e099e55ef5f1c7d3c8eaf14c0d5bcb9ec4de6314ea4e992307ea59369a136b37"
    sha256 cellar: :any_skip_relocation, big_sur:        "56555b8a3744a0af29b6bddcab2587457bb8622f78484b38fbbaceab88ea3f5b"
    sha256 cellar: :any_skip_relocation, catalina:       "aec38270a3b41a57fe6d05df08eea67042f2b65a2a5de30b2452afefd81a6d9d"
    sha256 cellar: :any_skip_relocation, mojave:         "0170dc610f0561cd562a2614f5bb0139cad5d37133a4181318a0edc08b3182c9"
    sha256 cellar: :any_skip_relocation, high_sierra:    "895c26dc74369ef72990fd79447e654f5266dda9c662d3bed2926caab7180678"
    sha256 cellar: :any_skip_relocation, sierra:         "aab86cfae41d1f4f9c93ad3a1680f21a5a0e9fad61190101582235174e4e214c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "10eb7df98a05c968f006bbda2c6f690bd7d5053e4bb6d2c9c4a043616648a23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "340dbf0c6e8f10d588a4a7c63edc14fe38c64cac809c2107f911d57f59a74f8c"
  end

  depends_on "go" => :build

  conflicts_with "ccrypt", because: "both install `ccat` binaries"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "./script/build"
    bin.install "ccat"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      I am a colourful cat
    EOS

    assert_match(/I am a colourful cat/, shell_output("#{bin}/ccat test.txt"))
  end
end
