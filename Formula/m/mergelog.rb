class Mergelog < Formula
  desc "Merges httpd logs from web servers behind round-robin DNS"
  homepage "https://mergelog.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mergelog/mergelog/4.5/mergelog-4.5.tar.gz"
  sha256 "fd97c5b9ae88fbbf57d3be8d81c479e0df081ed9c4a0ada48b1ab8248a82676d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ce8e33c95e90e9caa5bffd174dc681de874f7e20aee45d2c28888586dcd6ee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c9a6f46ecb8eecc32382ed046e0193aedef56b46f6edc613a72277b54af4327"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fbbc86f5661585c67f04b423a70e962b01f5921a0adebae09d0a6759e1396ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "27a98e08f04b9753c6bfc68b8d68e356fe40b9673e26084a77f936ccb5ff7696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a54a9a0a5fdc8927c2768cacd262c8184b9ec4e818d2f0b1deaf712d296235e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2121f7d6441648a072e935d24746e40c5c9a43e8e29f18e1c40abe103cda25a2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "src/Makefile.in", "mergelog.c -o", "mergelog.c $(LIBS) -o" unless OS.mac?
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mergelog", File::NULL
  end
end
