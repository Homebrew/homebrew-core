class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.11.tar.gz"
  sha256 "ae1122d7946c69ca17b3e2e672418957a1b3c6efa221eed62be7d5f7b5e3d0ea"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3143bad00e148c314f25e37badb7796c5890ba816b7654f624db05871e004214"
    sha256 cellar: :any,                 arm64_sonoma:  "7e9871c7d9bf2c7a91da45a4c44fc22fd1e567422912c036c1485bb4691c933f"
    sha256 cellar: :any,                 arm64_ventura: "d7916c67a1a411635211fc671b35c0d674079da1748df030be5d621ec372e1d0"
    sha256 cellar: :any,                 sonoma:        "922d22058c09a756855f2cce188bfeb95c21898ceef753574d505ff8f7054249"
    sha256 cellar: :any,                 ventura:       "ce2080def3035640960ed61538a3ce377f46b6767d74b49f03103889e14f57f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d45dda1e0800fd8b68c12b46e6209c94c500f0d17c1e0c7ff3c83353150b22c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ea92fa7dedbae7874668a64a298a9cd3a4cdaae71f818fc5fee4ebc22264b0"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
