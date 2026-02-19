class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www2.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/refs/tags/v9.5.25a.tar.gz"
  version "9.5.25a"
  sha256 "ab15b7fc5a96e8b4da1b76cc6c7935400879f8a54b0fcf94a947c02815f21006"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6389f8ee12843eb77bb7616c24e3a139ff00668a41c5d1bd0dade1a3f89cefd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "670c7d0db69776c23a1fb47a46f04e81879f7d15fa5480daf1904466addd8a96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcedcb08469ce0d12cc78a4430a38726bab27d02c2747c3bddcf1763c7095f91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97b1ec91900660d31bc530aff49aa30d7354501c7d94dc6b4520dfea770bdd35"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d4c55825605494439b932ea0b15ca777d20a2ba1f17d93cafbfee848ce97e08"
    sha256 cellar: :any_skip_relocation, ventura:       "88420a8637449dd69ae7e959176dd1a287565779f997cf73c1bf27a57f512bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e24c26298a3ec9764f6c38b55eb08220ee71ac8029130393908ea539659d6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f8c26a910871b5eaaf6ccbd110aff1fd188817edb466695df7c46275db0f5c3"
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
