class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.13.1.tar.gz"
  sha256 "15f24d26da0ccfc073abcdef0309f281e4684f2aa71126f826572c4c845e8dd9"
  license "MIT"
  head "https://github.com/jech/babeld.git", branch: "master"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f977cf0194b8bb8a3a60a434904a2a858b0b9f336176327800a731ef007ab1a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "62f048341c61438f5d7fade7659f694402543ca20d8fa7d06d42e87e42144e0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daa3da57b19ef571e1f7a235bc7ae6ce7ba610155b0f74b122e460e78d3c4e2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de3bd348ee96f4800eebf8e081ba0b02688dd47c05303f4bd7c47b8850a6bc97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "055e941a8174763608a1eb8b1953d2d60a75f6bd2ac5bc2f57235fc647b10bd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c95ab7121b226e24a505064d231e89efe854d2c373f6a362e987b22901ed1cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "df247b0cb0a9ba370ed3436aca781312806eec813a33a4b87008a8a09871e0ac"
    sha256 cellar: :any_skip_relocation, ventura:        "fa42c87c9b05ce203d457c7d6e288165ddb658bf830cd297b4fbe8c542ba40a8"
    sha256 cellar: :any_skip_relocation, monterey:       "69f0e27d20bf8a9febc3922bbcfe6d9ac84685751814d7f8747fcb3a2153d543"
    sha256 cellar: :any_skip_relocation, big_sur:        "3248b6ab94fada912bfdcb3521dc6c629a6e1a7bb09f9c1d33c232abcfc27a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8ee2de3eeddb40b1c2bc7f4eee384c0e14bc00e4b403cb5f8f46e2e0ba202dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e9228c77443e9d1c349091f0fecb2b5f61daaf340b99a6b2120def482a8f9a"
  end

  def install
    if OS.mac?
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    else
      system "make"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    assert_match "kernel_setup failed", (testpath/"test.log").read
  end
end
