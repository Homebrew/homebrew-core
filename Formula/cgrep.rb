class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.7.0.tar.gz"
  sha256 "a61dfdc97d29a61ab196ed4d4d68a2a31d690185e6cf42cf9d37b9d1a725a426"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c1d52cc310637e53841cda7ad606752523595fcf5cde0fdd225f69b053990622"
    sha256 cellar: :any,                 arm64_big_sur:  "25858aa7c4f6851083589571653bf47b278d304276596e475319f7165b28b18e"
    sha256 cellar: :any,                 monterey:       "a7a4ab449b83c4140802b90167e3751da0373bdd2af0e20737ee3c0b0049cfce"
    sha256 cellar: :any,                 big_sur:        "c802cbb5bae4c207cf1aa50add2c115621a20632a05129a386589c4b73ff036b"
    sha256 cellar: :any,                 catalina:       "1cde998562c4510e121298c30c12ccdc3b30f875950c6748103ab1d12469f740"
    sha256 cellar: :any,                 mojave:         "89bf1c8dacd4e56fd902ac26b5d0f89bac3fd314220fdb4c57f1fbb996d4db1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50bad499d6659e8c7d123f53cadc6e68711606cd97401495b3c2967f353a7a23"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
