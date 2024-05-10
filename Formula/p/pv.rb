class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.8.9.tar.gz"
  sha256 "a0789d8f8c5a08faf370b5a07d1d936aeff9504a4f49da76d4164797ac4606e6"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a3cebad88988de781b993b147abca1af00bf6fb780c48f5739ec18f65f28388"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5bf1a799cc81fac3b7f74d3742327a6b103a8161aef3d7a48efc9f16b58d4e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bb608be6d27d9c50281950caaff9b31699993ae26e6c8c22591d4dc934f2b6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "31e44d1e6e0fe7a78b06bace295651f6147e7ce0c281f351e7730eb7b46d1773"
    sha256 cellar: :any_skip_relocation, ventura:        "1c53d8e8739a820b63a0372ddf1339eee3c5015e878251c5c6458368f8f94dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "97289b0851c048871a403597054aa0a2678f7e7764de897c7a3c80a26ee99cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88cab24a96d59a1745c93b4bb53734915e74757a4da9a360089a4f513a3d3d15"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
