class Pev < Formula
  desc "PE analysis toolkit"
  homepage "https://pev.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.80/pev-0.80.tar.gz"
  sha256 "f68c8596f16d221d9a742812f6f728bcc739be90957bc1b00fbaa5943ffc5cfa"
  revision 1
  head "https://github.com/merces/pev.git"

  # Upstream fix for compatibility with OpenSSL 1.1
  # https://github.com/merces/pev/pull/104
  patch do
    url "https://github.com/merces/pev/commit/53eb494b.diff?full_index=1"
    sha256 "66eeadd149716597dfa4ecb6dc9c021cb6ab910aa4002b7730c822dd5c8ea654"
  end

  bottle do
    sha256 "e4d191b795eebb97ee0bb6a3122bf45f1c2f05c7b192381e712d96d71cd4ffb0" => :mojave
    sha256 "70c993e146e9d78b9d8d129f06c4a67071f110d286d87fccf1132a7022833a1b" => :high_sierra
    sha256 "228fda2113236b984e337abf64064684c2e14c8e73eb62367ad1bc5cbe43215b" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
