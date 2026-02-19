class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "https://gitlab.in2p3.fr/cc-in2p3-hpss-service/bbftp"
  url "https://pkg.freebsd.org/ports-distfiles/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  license "GPL-2.0-or-later"
  revision 3
  head "https://gitlab.in2p3.fr/cc-in2p3-hpss-service/bbftp.git", branch: "master"

  livecheck do
    url :head
    regex(/^(?:BBFTP|Version)[._-]v?(\d+(?:[._-]\d+)+[a-z]?)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_-", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d463140dea6d3abd1361442b054a2cd01020e40c55ca2e6046c5760944d689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58ae6876eec6565daf49ef57c1cc4663b2302ffb65d0acab11d8963ccbc0a42e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab14cc4e4e91fc506ca0b125d8d7ad3f5e84cc9019e2168a490f4da172ff481"
    sha256 cellar: :any_skip_relocation, sonoma:        "449c785073c769955666ce4833bb442984a2714629facd2a7b33dc218e429f20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e60edad50fab29170e6333b357a7e422bfe7798d190f2d0b21c8b72fbe4d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b43e533d6799fb7e77c30bd1c8e6707925647d7220edd00edda2e30177298c47"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL" if OS.mac?

    cd "bbftpc" do
      system "./configure", "--without-ssl", *std_configure_args
      system "make", "install"
    end
  end

  test do
    system bin/"bbftp", "-v"
  end
end
