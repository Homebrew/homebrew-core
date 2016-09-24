class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://projects.universe-factory.net/projects/fastd"
  url "https://projects.universe-factory.net/attachments/download/86/fastd-18.tar.xz"
  sha256 "714ff09d7bd75f79783f744f6f8c5af2fe456c8cf876feaa704c205a73e043c9"
  revision 1

  head "https://git.universe-factory.net/fastd/", :using => :git

  bottle do
    cellar :any
    sha256 "97cf3bcef653284348537ff8158afc77ec71361265f015d36a4735797b2c1546" => :el_capitan
    sha256 "5bb6c0dd9cec0aefa25dfe0f0949518381faf3e8ce961672bbe060cb6332adb0" => :yosemite
    sha256 "25a1180e91639faaaec33547ecb8e8e78cbbe876d3ee3e47d1ab61d09d243b39" => :mavericks
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
    args << buildpath
    mkdir "fastd-build" do
      system "cmake", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
