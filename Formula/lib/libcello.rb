class Libcello < Formula
  desc "Higher-level programming in C"
  homepage "https://libcello.org/"
  url "https://libcello.org/static/libCello-2.1.0.tar.gz"
  sha256 "49acf6525ac6808c49f2125ecdc101626801cffe87da16736afb80684b172b28"
  license "BSD-2-Clause"
  head "https://github.com/orangeduck/libCello.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?libCello[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38071f3aa78102240020ea1e40db1c431f87fbf8d6d07308cb3952bd46577b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a700988ca7ac195700131c8ff6f2c1b555d0446351c01cc2e2a6f22a65b70c2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "788079e8b941d6af2ee4c7f1fb84e1ed04072e85fb76a915203e04b0d0bfaaa6"
    sha256 cellar: :any_skip_relocation, ventura:        "2a9787e8b4a681876780ed84d5f5966c13ebcf754d14b6bd3a4ee4310cd3520b"
    sha256 cellar: :any_skip_relocation, monterey:       "96b8179944a4750d50e977d1b721569287476fa08fa8af3d832934c12c77761f"
    sha256 cellar: :any_skip_relocation, big_sur:        "171593b100ed2671982457816482a474c3be1223bad986a68df71803f3f6b435"
    sha256 cellar: :any_skip_relocation, catalina:       "a6ad4a498c30ce4713cf0a76800cabe412f1471a4262459ce38a477f163354e9"
    sha256 cellar: :any_skip_relocation, mojave:         "53ef17fbae26388e22354b9c5d536dfc0f0e0b604281878fbccbad7e6db5c30e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1c7719b74c5507dfd84ec93c043c11a4113e13a66f06e9d6f32349ec83042ad2"
    sha256 cellar: :any_skip_relocation, sierra:         "561319859455b756f53013090f91d6b06b1093c00d59593519ec09210f6bf830"
    sha256 cellar: :any_skip_relocation, el_capitan:     "05384667bb4d98a603406b3bc35962651af06d44eb55f2080c80f8dd979a9d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d935c25174d4315105cccb0a72dd60f184881d7929f9ca51aaaea2dd7262f28b"
  end

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "Cello.h"

      int main(int argc, char** argv) {
        var i0 = $(Int, 5);
        var i1 = $(Int, 3);
        var items = new(Array, Int, i0, i1);
        foreach (item in items) {
          print("Object %$ is of type %$\\n", item, type_of(item));
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lCello", "-lpthread", "-o", "test"
    system "./test"
  end
end
