class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.3.tar.gz"
  sha256 "e295b022e5187079b4cc5310447da5c787cb6bade86936dabf34a42bb85348ba"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2503013003907b8c61799bff250beab99dc7ebcdbe6393e8fec8ca31237a1fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "184e482468546611a17a93f755ac988aa44b3abe1d5740b4d653e8a0684c2fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "d9607a44df122ff814a718621ebc3ac5cfcf6b33395c21e3fca1a4cd54ff33e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "68c9fe6f9ae3bff9bc964cc07fe73b7a02f0189d179a6e7579a0b031fc9ce26e"
    sha256 cellar: :any_skip_relocation, catalina:       "094bff2b14bc31b0009f646ab03f6a1619af5647c801912a86ebff330c46c512"
    sha256 cellar: :any_skip_relocation, mojave:         "cf1b9ee5aaf57f8821e5208b59974953f676e26a9584ea5aa45b43b507a21369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e17beee69ada92813dabcf05ae0e05c1f39e7afe795cf0dc1ccf0dd1390d2ab"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
