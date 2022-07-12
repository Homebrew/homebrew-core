class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.22c.tar.gz"
  version "9.5.22c"
  sha256 "d3f9fd75994cfc7419c6ed1d872d0cc334dab3e20f6494776abd48b7cda43022"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bca290fbdf0ca232de14798bbb20cac5d57a88888c9a6f15c995fbbd24658a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "083a98c7f153248263f11d024d5b6f31b5d61a62eacd6895220a4bbba137c4ff"
    sha256 cellar: :any_skip_relocation, monterey:       "75c36f124a0b66637ec19b19e98267cb9697120153b34854a7047076dfa9c467"
    sha256 cellar: :any_skip_relocation, big_sur:        "637042132bae564bdf6fb700226c5760e84d6e05ade3a76948f581fd26319025"
    sha256 cellar: :any_skip_relocation, catalina:       "bccf79cc69df3329db76b21936d4c755b1144d028b220485c2734ba304c1a9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8c1dd917b0b3f025201f6dd08a7b5abf7dde9aefc43045bc2777c32eb7721e"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "macintosh"
    else
      "linux"
    end
    system "make", "Configure", "name=#{target}"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
