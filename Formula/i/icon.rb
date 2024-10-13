class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/refs/tags/v9.5.24a.tar.gz"
  version "9.5.24a"
  sha256 "73eaf9b1bd0d0bb21c252110e7e9e5d146ef37bef2cd72c46e023d71305fa801"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "61f468982087c6ca726218f316212869d7232f2367911ef95d55a8f75f9a0bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50c961d672798efd89cf786552fb5b13bb20fc5a69614557e00ce9869e7c433a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "887a3e2b038e7fcefaed54e5723e06430f5d85d39eeb0596eaee11699e8d2ee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2368ee3c88bc2b4f8a9893e17505ae1f5b7865ad6107c476e928fdbb059d22d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b22e92e8df2a03eb928266aadd6d14cde29e7382daa90d7baa01108fb6e2cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "a88a1dff7475114aa8ec7c0a01bb235f9aee0563b4791aa6b0d2dc41712566ca"
    sha256 cellar: :any_skip_relocation, monterey:       "7b404b8b761701feb03fb117175158c733e180e55a27a05405ba096dc9199a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9792ec4c98487c1b1d31e25376b2da6688d97dc2c5605e88684f043eb42e95e9"
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
