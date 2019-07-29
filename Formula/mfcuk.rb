class Mfcuk < Formula
  desc "MiFare Classic Universal toolKit"
  homepage "https://github.com/nfc-tools/mfcuk"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfcuk/mfcuk-0.3.8.tar.gz"
  sha256 "977595765b4b46e4f47817e9500703aaf5c1bcad39cb02661f862f9d83f13a55"

  bottle do
    cellar :any
    sha256 "715ca194ceaf40ef63f83f801479a2844663c564705282272805938b5747af6d" => :mojave
    sha256 "1dddb64e65b9fb1e387f2bd18ed2ae0f600aa868fa92a0141f66fb835a1e8dac" => :high_sierra
    sha256 "a4ae4d6f6cdec9dd28c52ff04da99b9de86c79a19c6e182ef3a557f48dde0741" => :sierra
    sha256 "8b329dbd3feb25bc4f04f40451cf25e832395721a5184eb4ee287366aaa06334" => :el_capitan
    sha256 "bdf696192e1a660b2fa1ad58498bdce941b1d45c4b51847b95427f41debd4c2d" => :yosemite
    sha256 "1394e4115a4e65abacc23e81659fd77475d6039ac39979cea7fd335ee5cf09e6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mfcuk", "-h"
  end
end
