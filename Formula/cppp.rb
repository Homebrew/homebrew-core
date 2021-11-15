class Cppp < Formula
  desc "Partial Preprocessor for C"
  homepage "https://www.muppetlabs.com/~breadbox/software/cppp.html"
  url "https://www.muppetlabs.com/~breadbox/pub/software/cppp-2.6.tar.gz"
  sha256 "d42cd410882c3b660c77122b232f96c209026fe0a38d819c391307761e651935"

  livecheck do
    url :homepage
    regex(/href=.*?cppp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9097e3035495a68bb2b930bf518926a897a23d68bf33b78e09db92741444f2c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24b206e97713f4f12168a2c1a29fe546b931e2da5b72b8ed050170522b1fabf5"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e48235f9462b6163c19354aae7a45780855163f603a552236e07bedd946845"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4e6c9586586b0c2d014cf83cd3cf0e1434f2643667900b0dfd4cb194f4f5b1c"
    sha256 cellar: :any_skip_relocation, catalina:       "29ce2b3314eaecc5873039675e85efb132a5ebfa9aac743d1b327b60f66c1122"
    sha256 cellar: :any_skip_relocation, mojave:         "cee25209e4a2ef97d118eac091fa7d5cb6c4ba91329bd713b7ae998e92aaf3c3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "93bc70ed7bfe05cf901c8cb8400253c0bce2d245cbb5f47698e8c81c81ed6a85"
    sha256 cellar: :any_skip_relocation, sierra:         "af58094ee1d80d6d09163b42755d827aa5b8be15b636a6ad087b334978ad2e38"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3bb773301b97402f783e506f3ccc339d7363df6e292d255d6b3209e5be8d1c1a"
    sha256 cellar: :any_skip_relocation, yosemite:       "7c18c1844a89ca3a0ee7084b06c908de2288378eaeac09c7872b0eae97129fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506ed1937e454dfd18842feaa90e2873eacad66b4920cfae8cba78f5b323f874"
  end

  def install
    system "make"
    bin.install "cppp"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      /* Comments stand for code */
      #ifdef FOO
      /* FOO is defined */
      # ifdef BAR
      /* FOO & BAR are defined */
      # else
      /* BAR is not defined */
      # endif
      #else
      /* FOO is not defined */
      # ifndef BAZ
      /* FOO & BAZ are undefined */
      # endif
      #endif
    EOS
    system "#{bin}/cppp", "-DFOO", "hello.c"
  end
end
