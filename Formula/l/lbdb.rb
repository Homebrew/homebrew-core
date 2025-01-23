class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.55.1.tar.gz"
  sha256 "fa9289c3137f0e95021bc848f40926874c2d43de685988688a38f41666865d4e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f0cda8bd82e482446ad7b8db04913190877742d1e309722e9631bdaf967b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d055509ac9bc7677fb5a7d41199766a7ab915b0663e69e58822fef78b5241829"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb0b0354f160f013bad882aced397a8bd50f60bb2150a64e0cddbfb0825a4429"
    sha256 cellar: :any_skip_relocation, sonoma:        "5638ebf0f42cffcb1d84a6f871cdb3297cb5d73f37c445b1b42d987ca3ace6eb"
    sha256 cellar: :any_skip_relocation, ventura:       "4b045c2798429dd21fdb2f90825a06b1785d48950d700f9310eaae36628884bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936539b41a0ab7f7cd8efaf11fe8d7779a3d93c45ed3b33b3bf14cdfb8c42ddb"
  end

  depends_on "abook"
  depends_on "khard"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
    assert_predicate lib/"lbdb/m_abook", :exist?, "m_abook module is missing!"
    assert_predicate lib/"lbdb/m_khard", :exist?, "m_khard module is missing!"
  end
end
