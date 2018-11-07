class Lcm < Formula
  desc "Libraries and tools for message passing and data marshalling"
  homepage "https://lcm-proj.github.io/"
  url "https://github.com/lcm-proj/lcm/releases/download/v1.3.1/lcm-1.3.1.zip"
  sha256 "3fd7c736cf218549dfc1bff1830000ad96f3d8a8d78d166904323b1df573ade1"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "8223454e139a3efd0972f0885b9d624377bed55496ff5bb0d3c9a5f6265a67c7" => :mojave
    sha256 "efd68dbb5defc150bc7be3d8ab2e9d5b5faa1d751fb49cb21eb0c9997b0617e8" => :high_sierra
    sha256 "73d7b08663a9f318a5804476f29f55d08c733aebc2037405b4147f52942b09a0" => :sierra
  end

  head do
    url "https://github.com/lcm-proj/lcm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "xz" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :java => "1.8"

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
