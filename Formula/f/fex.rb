class Fex < Formula
  desc "Powerful field extraction tool"
  homepage "https://www.semicomplete.com/projects/fex/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/semicomplete/fex-2.0.0.tar.gz"
  sha256 "03043c8eac74f43173068a2e693b6f73d5b45f453a063e6da11f34455d0e374e"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1baf47daa289d9a7d09cfdb695a4a1a51841458d992bbadc68a27780f81d7182"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ee2c09154b30ee5c0ec51ee562d4efc6528e1d69761810cb1eae30fec98bea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb8ef2d1b057c6cc2c462f6398911d8f55a85398b6eaf60f26c01a7cb3f87e04"
    sha256 cellar: :any_skip_relocation, ventura:        "ba9dc477aa675909383c9bbda166b0786254fea4898afa1c46c6b85a3400d11f"
    sha256 cellar: :any_skip_relocation, monterey:       "c227531dc137d14bcfefc19b9a385d5ae842e5f89b1e1b2e75b969b18786c522"
    sha256 cellar: :any_skip_relocation, big_sur:        "48289f9a071052a99a7ff520feb793abe0cfd3c81b939bf767cc3bb51ac09918"
    sha256 cellar: :any_skip_relocation, catalina:       "ddc12a1eefc9238e48ba57f00694e6b01cdce2ef41bcf34ddfd405696d3a7a65"
    sha256 cellar: :any_skip_relocation, mojave:         "c3daa86f0f51e3bd7be8cd890a46bd2a50e6a0fb728f664ce1847edb6b5f7f0c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1b293789f75a67d36037f9d80641814119c8f4534a78dbf321744276a41f2c15"
    sha256 cellar: :any_skip_relocation, sierra:         "e42328824017f1432ace562fdd70061e504c5524d2702f3d4b470c40b1bf105e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "952c166ae7efc5c7955bba3c54fefc1e5c18fe2296804b15554a8703285034e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ec5c054bfa085ae8e70f521aa235ddae7a2a481f4b9512751490c8a5166c09"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "foo", pipe_output("#{bin}/fex 1", "foo bar", 0).chomp
  end
end
