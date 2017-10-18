class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.38.5.tar.xz"
  sha256 "0f8c8f3568189c14eb20d792b759c6f22b6a35f47b4fe4abd52000160c7de2ed"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "a57748ae61bdd4167412a606e2f916efa768709449598881d511bcd92fe7018c" => :high_sierra
    sha256 "7db2b0814ce6d893f94cafe8a581e440904410f45ddad1decdc232f60e94a962" => :sierra
    sha256 "1e8e4f39c45ad7b23ea7fa66e6c7ba390508f08869cf0b7f4d1468a2c8d51b51" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
