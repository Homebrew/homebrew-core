class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.22e.tar.gz"
  version "9.5.22e"
  sha256 "e09ab5a7d4f10196be0e7ca12624c011cd749fc93e50ad4ed87bd132d927c983"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d1df54b9d3a87b0630483f3538f4558690ee1f30b6e0aa33dab177cdc51891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e088bb6a1e7cdb42829ae36a9ac57f35cc8fda51d07708a4995cc2f0d3686330"
    sha256 cellar: :any_skip_relocation, monterey:       "4605a372db6da6286243fc923e301f771c2da810715318a9e49b6e363c5b4f79"
    sha256 cellar: :any_skip_relocation, big_sur:        "653244770e5f013dcfa49781ad646d7b2f5bd07469542d79fd30f9ffa0ecbc2e"
    sha256 cellar: :any_skip_relocation, catalina:       "c926ffd95dde7ec76760cc4dc07863042e03d5a45dff65983b13b1bce1e069c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52b2122ba82e6432520c86e7c31074962fd4e4712b78478cb1677b417ac7605"
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
