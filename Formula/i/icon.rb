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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee6ffb72b0d16c041e5c3ea89fc3a2d3a5361f0188a4424c380b503d7752aaf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b881bd78c52d53cc0fa461db50bebfaa3c938a4aca48e1dc3707f8d8708533"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbd4950d7c8beb19264d472245baba21ba73d01677122e619beb0e7c33e77f89"
    sha256 cellar: :any_skip_relocation, ventura:        "cb1003aa133c33ec3d2bbea9b1c0b957287e207c3baf8ea900558ac336417c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "84ad1fd67613956eef4f81baa575376d13871b9eb281b88fad482d7d467051ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ca9796155abe1bdeb8375b564cb0438c599f88de7f34acd52365edf644c2664"
    sha256 cellar: :any_skip_relocation, catalina:       "6d45d0a928ff6d7f5bf37797cfe85a7f7e0319b2f57783a2401b19892f0f0831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3894f311892055d393661a75fc398e710b218da79c13b96954cfbe26659b7143"
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
