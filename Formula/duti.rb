class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a59aee7e9d902583006de7c7a16fd833d117a18a30d2eb880a2e4cc99a4d232" => :high_sierra
    sha256 "49718973f912e48ab7ee59564b1435fe22b85d395de58070f3089d7f6104bd8d" => :sierra
    sha256 "76f7600bdeab56e7d82e1939ad7287564189de62eb4a8e9352cd33dc04c8e697" => :el_capitan
  end

  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
