class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.8.tar.gz"
  sha256 "950027e1780787ca88271570aae890e0ac9b906f764554c2dee263d4cf7b74b8"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2fed19e1ff9ada579f2508827a46a023c98b7d979adbacd06b8401f2e3384af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad9e8474371b839efc6dd11f415f05e5c9c17ebe8b9a141b840808f3981d80f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "191155f3f2fce16f50101d1e644eed96f4aab06255cf0a2ffd4364ac7a1ddda1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3ff19030c1d80ea6169e7cdd3b542c3e33093f160b81770bdc11f912a1f9dc"
    sha256 cellar: :any,                 arm64_linux:   "d83a772ad73e8f69085249e0eccce608071959ab16c31c0a90c5f65774fb0ee9"
    sha256 cellar: :any,                 x86_64_linux:  "11d2d6aa63b5277ef37dfca8604514407057fd9469c725b6ed39fd5ec3ab9698"
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # install is not thread-safe
    system "make", "install"
  end

  test do
    assert_equal "&#20320;&#22909;", pipe_output("#{bin}/xml2asc", "你好")
  end
end
