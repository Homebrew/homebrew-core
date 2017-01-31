class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "http://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.2.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.2.tar.gz"
  sha256 "b03446fa4b549af5ebe4d35d7aba51163442d255660558cd861ebce536824aa0"

  bottle do
    sha256 "b9e174a86ba5d8801e8c13d5e6629e3ee1133236e4839f1a150c18d7142f7db6" => :sierra
    sha256 "ec5da5bee84826207290f09bd74d913e2e99c937cb70104e3ab818251c21f794" => :el_capitan
    sha256 "e333157196ce196c998cc46e2dec0a73fd3b49969dda9262effb8a565b591f1b" => :yosemite
    sha256 "e082a0eb2ffa11d107574d72197a22208e71bdfa9e8993187933bffb89b8b603" => :mavericks
    sha256 "c22dd6aeadd6465d796957705595f4333072f1c6c6087de5131931c70467e9e7" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
