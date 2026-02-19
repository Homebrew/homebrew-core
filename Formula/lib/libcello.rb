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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f29b04252a3f79f89b5ed93d519639c4cf6c6033036d42d8a60567f466a19a96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0e380cf6073b22792954d22559177ff5ff3cbaf11fbe00948c27b675338ff116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a2bbf7d05757a81aabb00b595b864d6a531004d0d0d02f70ef6763fe2621ab9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38071f3aa78102240020ea1e40db1c431f87fbf8d6d07308cb3952bd46577b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a700988ca7ac195700131c8ff6f2c1b555d0446351c01cc2e2a6f22a65b70c2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "788079e8b941d6af2ee4c7f1fb84e1ed04072e85fb76a915203e04b0d0bfaaa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7df5b2e7c6043f55d4645de61b2948a57607f2269e78769fd9a616d1b5fc00c"
    sha256 cellar: :any_skip_relocation, ventura:        "2a9787e8b4a681876780ed84d5f5966c13ebcf754d14b6bd3a4ee4310cd3520b"
    sha256 cellar: :any_skip_relocation, monterey:       "96b8179944a4750d50e977d1b721569287476fa08fa8af3d832934c12c77761f"
    sha256 cellar: :any_skip_relocation, big_sur:        "171593b100ed2671982457816482a474c3be1223bad986a68df71803f3f6b435"
    sha256 cellar: :any_skip_relocation, catalina:       "a6ad4a498c30ce4713cf0a76800cabe412f1471a4262459ce38a477f163354e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "563e0e5d5ee43073bccca6c732787f32af5a864fc9bcbf3854049cfc0f99ff37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d935c25174d4315105cccb0a72dd60f184881d7929f9ca51aaaea2dd7262f28b"
  end

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lCello", "-lpthread", "-o", "test"
    system "./test"
  end
end
