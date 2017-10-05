class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://projects.universe-factory.net/projects/fastd"
  revision 3

  head "https://git.universe-factory.net/fastd/", :using => :git

  stable do
    url "https://projects.universe-factory.net/attachments/download/86/fastd-18.tar.xz"
    sha256 "714ff09d7bd75f79783f744f6f8c5af2fe456c8cf876feaa704c205a73e043c9"

    # https://projects.universe-factory.net/issues/239
    # https://projects.universe-factory.net/projects/fastd/repository/revisions/2fa2187
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c2c6049/fastd/patch-xcode8-clock_gettime.diff"
      sha256 "dfa07eccf01a84a6e5eacc82c47c2cd5ba216e1f5032b41d2cef32e0b205ba9c"
    end
  end

  bottle do
    cellar :any
    sha256 "2fadce94f9be85aaa001ff349a883338afd84e92bf46e7304b5369f566c0bc4d" => :high_sierra
    sha256 "c677903580193501b1c9f261db458439a4b1faf16bb6f2d653bfbded0c27573a" => :sierra
    sha256 "101454fa20fdae38fc728f9a0fed65422b5931ccfac649c91e31e7bb52567fe0" => :el_capitan
    sha256 "71271192803a9b291017cc6779219e771c547d45026327c065d9a997d7f6b562" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libuecc"
  depends_on "libsodium"
  depends_on "bison" => :build # fastd requires bison >= 2.5
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl" => :optional
  depends_on :tuntap => :optional

  def install
    args = std_cmake_args
    args << "-DENABLE_LTO=ON"
    args << "-DENABLE_OPENSSL=ON" if build.with? "openssl"

    # https://projects.universe-factory.net/issues/251
    args << "-DWITH_CIPHER_AES128_CTR_NACL=OFF"

    mkdir "fastd-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
