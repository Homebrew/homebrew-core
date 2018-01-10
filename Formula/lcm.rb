class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip"
  sha256 "3fd7c736cf218549dfc1bff1830000ad96f3d8a8d78d166904323b1df573ade1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "50c9a39de7592b1685e4072b0f53880751a5af7ccc5667d1b8c633e15ee474ff" => :high_sierra
    sha256 "9dcbc09da69140c343224fa1851d4c03c90908254d882aad467e189e95cbd610" => :sierra
    sha256 "58d75c428869f70200220e5948468805f61a4190ca775e1f693c42cce72edc9f" => :el_capitan
    sha256 "41819c23b58c30b04c44864f2b820f0aa47b8805d78b39b5c6a023588c0cb1fb" => :yosemite
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
  depends_on "python" => :optional
  depends_on "python3" => :optional

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
    if build.with? "java"
      system "#{bin}/lcm-gen", "-j", "example_t.lcm"
      assert_predicate testpath/"exlcm/example_t.java", :exist?, "lcm-gen did not generate java file"
    end
  end
end
