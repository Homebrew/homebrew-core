class Libxdamage < Formula
  desc "X.Org: X Damage Extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdamage-1.1.6.tar.xz"
  sha256 "52733c1f5262fca35f64e7d5060c6fcd81a880ba8e1e65c9621cf0727afb5d11"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "db698e2d52193a57afcd2b9886a4db3d6c513e7ef127c6bb96a566a126b9d0d1"
    sha256 cellar: :any,                 arm64_sequoia:  "4378ada6b14fdbf06d82825d2d81465fb0be5d80684c0c46b73ec6bf8b1009e9"
    sha256 cellar: :any,                 arm64_sonoma:   "3c19b70d6cd2fd2720b9b52be6c21ba5032da5e94fd3584126a5b73c725e18ba"
    sha256 cellar: :any,                 arm64_ventura:  "f7ba5d6474c6d7be855f270e843c42d1e3b819d43e7d96c3b62789265f264a3b"
    sha256 cellar: :any,                 arm64_monterey: "1b820498fc3f7216bcf074f0c8165875a0250390e837d9db05a62bb9ada85d5b"
    sha256 cellar: :any,                 arm64_big_sur:  "e80bbc3be1914e6a890f446dca34b789b0c0746bb0bf78426bd8d3137b771f13"
    sha256 cellar: :any,                 sonoma:         "4264c852ce781f7afdaa935f7e56994f0d1f90412c37acaa654b3c1b1f9bbafd"
    sha256 cellar: :any,                 ventura:        "0a57b493cab139a05dfd0d497b01a98525161094a456568fe35175043bd5f792"
    sha256 cellar: :any,                 monterey:       "f4a6249de91d6f556fe83f4d092233a7b45dff9fe2a3dcf7c23f43e8cb502b9a"
    sha256 cellar: :any,                 big_sur:        "682e7654ca8a9c91c37b156e173f2280fef06e51ba6604062a8fc3966ef01028"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ff8793c23cc1bcc97ab649cfae7bdc9b4756d8635bc1bf1ff554d3b14e31854b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d888f5feb3f6cbaf35ca9d4f6af015555e30be8295bb378594290081e74c29f"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/Xdamage.h"

      int main(int argc, char* argv[]) {
        XDamageNotifyEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
