class Lcm < Formula
  desc "libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip"
  sha256 "3fd7c736cf218549dfc1bff1830000ad96f3d8a8d78d166904323b1df573ade1"

  bottle do
    sha256 "f497b00f04c3ae210117ffdca9c7ceb45cfe2e758f6e9010a0925448bc60ce85" => :el_capitan
    sha256 "55c51b12f9715324bc904873a8aa499a7e9abe0e3d36bc26efc7105766853221" => :yosemite
    sha256 "b9c5b23777fa2b1d824022c3fb039fbabcd2aa3c46cb02ea61d9998fd506bd35" => :mavericks
  end

  head do
    url "https://github.com/lcm-proj/lcm.git"

    depends_on "xz" => :build
    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :java => :recommended
  depends_on :python => :optional
  depends_on :python3 => :optional

  def install
    ENV.java_cache

    if build.head?
      system "./bootstrap.sh"
    else
      # This deparallelize setting can be removed after an upstream release
      # that includes the revised makefile for the java part of LCM.
      #
      # (see https://github.com/lcm-proj/lcm/pull/48)
      #
      # Note that the pull request has been merged with the upstream master,
      # so it will be included in the next release of LCM.
      ENV.deparallelize
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"example_t.lcm").write <<-EOS.undent
      package exlcm;

      struct example_t
      {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system "#{bin}/lcm-gen", "-c", "example_t.lcm"
    assert(File.exist?("exlcm_example_t.h"), "lcm-gen did not generate C header file")
    assert(File.exist?("exlcm_example_t.c"), "lcm-gen did not generate C source file")
    system "#{bin}/lcm-gen", "-x", "example_t.lcm"
    assert(File.exist?("exlcm/example_t.hpp"), "lcm-gen did not generate C++ header file")
    if build.with? "java"
      system "#{bin}/lcm-gen", "-j", "example_t.lcm"
      assert(File.exist?("exlcm/example_t.java"), "lcm-gen did not generate java file")
    end
  end
end
