class Atool < Formula
  desc "Archival front-end"
  homepage "https://savannah.nongnu.org/projects/atool/"
  url "https://download.savannah.gnu.org/releases/atool/atool-0.39.0.tar.gz"
  sha256 "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/atool/"
    regex(/href=.*?atool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    manifest_sha256 "781a343f2c0b7df366bd18fd6889744b74d484e024bd4df2551d7664b116b7fe"
    sha256 cellar: :any_skip_relocation, all: "7bdc1cec48daaf7c140aa3ebb5e32ea863e560947ff2ed110339f84bdcea25c4"
  end

  deny_network_access!

  def install
    # Build an `:all` bottle.
    files = %w[ChangeLog README]
    files.each { |file| rm buildpath/file }

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "example.txt"
    touch "example2.txt"
    system bin/"apack", "test.tar.gz", "example.txt", "example2.txt"

    output = shell_output("#{bin}/als test.tar.gz")
    assert_match "example.txt", output
    assert_match "example2.txt", output
  end
end
