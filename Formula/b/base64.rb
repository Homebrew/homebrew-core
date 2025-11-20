class Base64 < Formula
  desc "Encode and decode base64 files"
  homepage "https://www.fourmilab.ch/webtools/base64/"
  url "https://www.fourmilab.ch/webtools/base64/base64-1.5.tar.gz"
  sha256 "2416578ba7a7197bddd1ee578a6d8872707c831d2419bdc2c1b4317a7e3c8a2a"
  license :public_domain

  livecheck do
    url :homepage
    regex(/href=.*?base64[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fbf459526bc50316ed55f1e5ea972f22658ba26aa8e0b4b5db5b984bc0fbceb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "17aef54e36b9c3ce2cd832c59d4cacbac0584a1a9db7af45e1728d6fceeb760e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8d7991eaf3b922668f4da81929e574d1ce879acf372ffc8a24679da63e83967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc888655b142849238c7aa9764e462c4f30a94c80c682962bddea75c96dc581d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa86de79c32e57cf11fceeba4ab6ccdbd4bccbf88704e85b7f9bae100f9af236"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddaa699165e82146b4f3b476d05cff364a9530d1c389d43573b8f59a2a2e7d5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a15a0d6f82a026a34550257e7dda5bfc81a7d12414d7d28bcfec4df9882f7bb"
    sha256 cellar: :any_skip_relocation, ventura:        "6fe7f731c8dae0f98208beedf2610c71cac50df042d133612fe9be00864cfec5"
    sha256 cellar: :any_skip_relocation, monterey:       "283b796362540fd1f3a006f537bc87c92cfe1c47071eb8d2d2c863334ada81d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c9e32d24df53a042aec56518070159c224216e16346f7f567a4261521609efd"
    sha256 cellar: :any_skip_relocation, catalina:       "f883e1602433f3a921fd1892747d76cf4548f75ac2e572be9eb0cfe0ced7290c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "37aa1f30a578bdc6344258b905cf1e714d2dbc6323cbace378c07760d18e9817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f8f96bcf972f99b8ca838f542a44c9b1f7bf8da7e66eb3333d941093ecbc199"
  end

  conflicts_with "aklomp-base64", because: "both install `base64` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    bin.install "base64"
    man1.install "base64.1"
  end

  test do
    path = testpath/"a.txt"
    path.write "hello"
    assert_equal "aGVsbG8=", shell_output("#{bin}/base64 #{path}").strip
  end
end
