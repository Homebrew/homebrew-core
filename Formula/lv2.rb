class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.18.2.tar.bz2"
  sha256 "4e891fbc744c05855beb5dfa82e822b14917dd66e98f82b8230dbd1c7ab2e05e"
  license "ISC"

  livecheck do
    url "https://lv2plug.in/spec/"
    regex(/href=.*?lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "757cd306cc72fb5517d4b2226eaa8addc9e8ca807fa576d025d921a8b25a3382" => :big_sur
    sha256 "37eebb5f3d7e92a4339be7fdf5f63a5493e36ad1ef71369aa9d9ecc8b3d41ef7" => :arm64_big_sur
    sha256 "3fc9a00fcb361d6d87e101733497abad39e33b299774229bc484af15a59d2e55" => :catalina
    sha256 "0897d136c566648ff5acf40760ff064bdeda779c4afc6a31f02741a08083c5f8" => :mojave
  end

  depends_on :macos # Due to Python 2

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--no-plugins", "--lv2dir=#{lib}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
