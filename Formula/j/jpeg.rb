class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9f.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9f.tar.gz"
  sha256 "04705c110cb2469caa79fb71fba3d7bf834914706e9641a4589485c1f832565b"
  license "IJG"

  livecheck do
    url "https://www.ijg.org/files/"
    regex(/href=.*?jpegsrc[._-]v?(\d+[a-z]?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a9c4c46243ca95babeaa9779c982c90b134ce326124d75af8cd1cce071d5941c"
    sha256 cellar: :any,                 arm64_sequoia:  "0c2e03678c6b74d190096c547c337769d6678bd41eda71d6688e465825c4b003"
    sha256 cellar: :any,                 arm64_sonoma:   "15c7bc3002bdb1f9281a9621d4d9c7722142aab09cc983e950b24d78c7a8744b"
    sha256 cellar: :any,                 arm64_ventura:  "3492c054e815cb4843932d27bb943b5ae325acc25219049afd1790c2d549787e"
    sha256 cellar: :any,                 arm64_monterey: "f698f979cdbeb8590ff70cc40ab87a747bf955f37473767673a1f315cce0503c"
    sha256 cellar: :any,                 sonoma:         "bcdf0adaf6ef9dca1cf1dbf1416e1009cb5b1770ec9116d0e2f4d8c757784131"
    sha256 cellar: :any,                 ventura:        "73cc0431645e763135f43442f3c9e135069a491eff2d885f4b91cece123482cf"
    sha256 cellar: :any,                 monterey:       "b582d67ae81e6e165fe33ab760f557c06399f963b345d6a68ff6b63abbfdca24"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "beeefc584dc196ae25fdd83cbbc19d803aa076f9094a405002d4d37ad5a2a6d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da8a41595d64ce98d7ce8ec9c8bfd0a60ffd0da99313ab923387fb588f0a29a"
  end

  keg_only "it conflicts with `jpeg-turbo`"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"djpeg", test_fixtures("test.jpg")
  end
end
