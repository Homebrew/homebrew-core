class Libusrsctp < Formula
  desc "Portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://github.com/sctplab/usrsctp/archive/0.9.3.0.tar.gz"
  sha256 "a4573b1cd7b8fc2fce476df61093736d3fea9eef5c87d72e66768c0a6b1f9e39"
  head "https://github.com/sctplab/usrsctp.git"

  bottle do
    cellar :any
    revision 2
    sha256 "bf05bbef72c45daec3f682b9c12a4ad838ad5c02e1814cbfa837e610140988a3" => :el_capitan
    sha256 "7b681d68a1dca9792595dce4dc2d677e5a578ed5027dee6ba4dc312cd3f5119b" => :yosemite
    sha256 "a42402bb65451da92fd33b86ba33a4c1f75d8931830437d866d5298f3c2818cf" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <unistd.h>
      #include <usrsctp.h>
      int main() {
        usrsctp_init(0, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lusrsctp", "-o", "test"
    system "./test"
  end
end
