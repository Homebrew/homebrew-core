class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip"
  sha256 "3fd7c736cf218549dfc1bff1830000ad96f3d8a8d78d166904323b1df573ade1"
  revision 1

  bottle do
    cellar :any
    sha256 "e14ef8beac71ba643f8794caf62b9e9b4059a3f4687dba5470af43f1983147a0" => :high_sierra
    sha256 "9b4244f4884bcbf572f44becf98509001add67ca0117a05180cc28ca6e53acbc" => :sierra
    sha256 "c3cf28a9d9c7d57846c17580dfb56c5516e06a728f6ec8f98edbcfcf2328ac39" => :el_capitan
  end

  head do
    url "https://github.com/lcm-proj/lcm.git"

    depends_on "xz" => :build
    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  deprecated_option "with-python3" => "with-python"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :java => "1.8"
  depends_on "python" => :optional
  depends_on "python@2" => :optional

  def install
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
    (testpath/"example_t.lcm").write <<~EOS
      package exlcm;

      struct example_t
      {
          int64_t timestamp;
          double position[3];
          string name;
      }
    EOS
    system "#{bin}/lcm-gen", "-c", "example_t.lcm"
    assert_predicate testpath/"exlcm_example_t.h", :exist?, "lcm-gen did not generate C header file"
    assert_predicate testpath/"exlcm_example_t.c", :exist?, "lcm-gen did not generate C source file"
    system "#{bin}/lcm-gen", "-x", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.hpp", :exist?, "lcm-gen did not generate C++ header file"
    system "#{bin}/lcm-gen", "-j", "example_t.lcm"
    assert_predicate testpath/"exlcm/example_t.java", :exist?, "lcm-gen did not generate java file"
  end
end
