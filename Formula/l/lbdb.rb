class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.57.tar.gz"
  sha256 "212fe2e40df5ed3e5496bc5e821e4b0683a6c9523b8885e7e87b634bcf923a88"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2120f8513be26847edc720538c984096ce0db0e578e72861da8bfe24e901193"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fdebcd4e348d44fa5db0210b5cfeb7f8ccd991f20366f8cd6159ec3379889a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c87f48b3bcc0a881dd88b442fe41ba82ca074b16e5fb3b2ecea2f8e84c33d46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "95f58929f611fb23c2760e602fa24bd697ee4143806cf288997d15af850645fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e4f84e4507fc2466f448de00796e0b094fdebd9e1293186d44ce99427b680c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141c0b2ca83409c152474550675f2e8da9ff5989855141abcba1a782c1fd0d7e"
  end

  depends_on "abook"
  depends_on "khard"

  def install
    system "./configure", "--libexecdir=#{lib}/lbdb", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
    assert_path_exists lib/"lbdb/m_abook", "m_abook module is missing!"
    assert_path_exists lib/"lbdb/m_khard", "m_khard module is missing!"
  end
end
