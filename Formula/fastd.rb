class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://projects.universe-factory.net/projects/fastd"
  revision 4
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
    sha256 "81dbae981699f6be12675b2f3506071fd2fcc7928f8f1744ac76abb48a1c1104" => :mojave
    sha256 "19dc7f2bf518b8f9374fcfbc7e73fa0ca330d6eb23d92be4b6e2e6a5771fdc6d" => :high_sierra
    sha256 "e209a7908ab196c614fd8a21d76bfbfc8c73a699784834457e0c1da6eed24a43" => :sierra
    sha256 "e097588f07f37954bbb525e7f08a9d69dd9bb18bff63616aa942329f7fe15dc1" => :el_capitan
  end

  depends_on "bison" => :build # fastd requires bison >= 2.5
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
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
