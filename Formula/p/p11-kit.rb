class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.3/p11-kit-0.25.3.tar.xz"
  sha256 "d8ddce1bb7e898986f9d250ccae7c09ce14d82f1009046d202a0eb1b428b2adc"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "cd5ef135c54d2a312c17af15e9f3c807b3b37a65388b64a35a4d215b54745789"
    sha256 arm64_ventura:  "f965f464d9c3b641003d924bcea428586ec8572dd0ed54f41b879ef727b4b4e9"
    sha256 arm64_monterey: "3bc4bc733ac93bdb69cad61da77152e17758613736eddbd2b1518145a24efa21"
    sha256 sonoma:         "c09253484c1237e942e0c91586422abae0b3af1c026bb5cce3bcd5900ad690cc"
    sha256 ventura:        "c4b2c1001b5add01313ec51f2786b2744d13eb86bf13ef88f1fa4a581ef69bdb"
    sha256 monterey:       "37d1d22a9b656be0423b9a410701dcc2d5ab12ec4b33bc0806a608a1e3680dbe"
    sha256 x86_64_linux:   "4f7ca2105451e0561951b327254cb179505798e8b5c491e9e4ee9124b0855397"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "libtasn1"

  uses_from_macos "libffi", since: :catalina

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    args = %W[
      -Dsystem_config=#{etc}
      -Dmodule_config=#{etc}/pkcs11/modules
      -Dtrust_paths=#{etc}/ca-certificates/cert.pem"
      -Dsystemd=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    # This formula is used with crypto libraries, so let's run the test suite.
    system "meson", "test", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
