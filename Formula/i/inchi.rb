class Inchi < Formula
  desc "IUPAC International Chemical Identifier"
  homepage "https://www.inchi-trust.org/"
  url "https://github.com/IUPAC-InChI/InChI/releases/download/v1.07.1/INCHI-1-SRC.zip"
  sha256 "fe6e1ee25714988f7b86420b7615b4e1d7c01fda9b93d63b634a0c021ac9f917"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b229ca55644d5c53c2cd5c070f631a4379806e44059bd370e61d4b94b0b0e784"
    sha256 cellar: :any,                 arm64_sonoma:  "c4488a6860bbcc789c950bfca39a2b613259346d9abfc822bfa863fcdeaf6427"
    sha256 cellar: :any,                 arm64_ventura: "f8e910c3ca6711c1a0fb70ce5a4392665e85a2b8c39d1911911346d9475302f1"
    sha256 cellar: :any,                 sonoma:        "6db049c16f2625d44e971bf9626d58bce066cf698e0eaeb29a889b13c8850f9a"
    sha256 cellar: :any,                 ventura:       "da10c8873201f570b9797d45f80e88afb35de4654c541f21ea4888dac8d99c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df02aacc34873e732291793847d59d6ca4ebee54a4956372ec4dc03d9fe88729"
  end

  # These used to be part of open-babel
  link_overwrite "include/inchi/inchi_api.h", "lib/libinchi.dylib", "lib/libinchi.so"

  # Fix dylib file names
  # PR ref: https://github.com/IUPAC-InChI/InChI/pull/62
  patch :p2, :DATA

  def install
    bin.mkpath
    lib.mkpath

    args = ["C_COMPILER=#{ENV.cc}", "BIN_DIR=#{bin}", "LIB_DIR=#{lib}"]
    system "make", "-C", "INCHI_API/libinchi/gcc", *args
    system "make", "-C", "INCHI_EXE/inchi-1/gcc", *args

    # Add major versioned and unversioned symlinks
    libinchi = shared_library("libinchi", version.to_s[/^(\d+\.\d+)/, 1])
    odie "Unable to find #{libinchi}" unless (lib/libinchi).exist?
    lib.install_symlink libinchi => shared_library("libinchi", version.major.to_s)
    lib.install_symlink shared_library("libinchi", version.major.to_s) => shared_library("libinchi")

    # Install the same headers as Debian[^1] and Fedora[^2]. Some are needed by `open-babel`[^3].
    #
    # [^1]: https://packages.debian.org/sid/amd64/libinchi-dev/filelist
    # [^2]: https://packages.fedoraproject.org/pkgs/inchi/inchi-devel/fedora-rawhide.html#files
    # [^3]: https://github.com/openbabel/openbabel/blob/master/cmake/modules/FindInchi.cmake
    (include/"inchi").install %w[ichisize.h inchi_api.h ixa.h].map { |header| "INCHI_BASE/src/#{header}" }
  end

  test do
    # https://github.com/openbabel/openbabel/blob/master/test/files/alanine.mol
    (testpath/"alanine.mol").write <<~EOS

        Ketcher 02131813502D 1   1.00000     0.00000     0

        7  6  0     0  0            999 V2000
          1.0000    1.0000    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
          1.0000    2.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          1.8660    2.5000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.5000    2.8660    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          2.7321    2.0000    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
          1.8660    3.5000    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    2.0000    0.0000 H   0  0  0  0  0  0  0  0  0  0  0  0
        1  2  1  0     0  0
        2  3  1  0     0  0
        2  4  1  1     0  0
        3  5  1  0     0  0
        3  6  2  0     0  0
        2  7  1  6     0  0
      M  END
      $$$$
    EOS

    assert_equal <<~EOS, shell_output("#{bin}/inchi-1 alanine.mol -STDIO")
      Structure: 1
      InChI=1S/C3H7NO2/c1-2(4)3(5)6/h2H,4H2,1H3,(H,5,6)/t2-/m0/s1
      AuxInfo=1/1/N:4,2,3,1,5,6/E:(5,6)/it:im/rA:7nNCCCOOH/rB:s1;s2;P2;s3;d3;N2;/rC:1,1,0;1,2,0;1.866,2.5,0;.5,2.866,0;2.7321,2,0;1.866,3.5,0;0,2,0;
    EOS
  end
end

__END__
diff --git a/INCHI-1-SRC/INCHI_API/libinchi/gcc/makefile b/INCHI-1-SRC/INCHI_API/libinchi/gcc/makefile
index 6d5a722..5b953ed 100644
--- a/INCHI-1-SRC/INCHI_API/libinchi/gcc/makefile
+++ b/INCHI-1-SRC/INCHI_API/libinchi/gcc/makefile
@@ -175,7 +175,7 @@ else ifeq ($(OS_ID),2)
 # jwm: linking to .dylib on OS X
 $(API_CALLER_PATHNAME) : $(API_CALLER_OBJS) $(INCHI_LIB_PATHNAME).so$(VERSION)
 	$(LINKER) -o $(API_CALLER_PATHNAME) $(API_CALLER_OBJS) \
-$(INCHI_LIB_PATHNAME).dylib$(VERSION) -lm
+$(INCHI_LIB_PATHNAME)$(VERSION).dylib -lm
 else
 # djb-rwth: linking to .so on Linux
 $(API_CALLER_PATHNAME) : $(API_CALLER_OBJS) $(INCHI_LIB_PATHNAME).so$(VERSION)
@@ -253,9 +253,9 @@ $(INCHI_LIB_PATHNAME).dll$(VERSION): $(INCHI_LIB_OBJS)
 $(INCHI_LIB_OBJS) -Wl$(LINUX_MAP),-soname,$(INCHI_LIB_NAME).dll$(VERSION) -Wl,--subsystem,windows -lm
 else ifeq ($(OS_ID), 2)
 # jwm: creating .dylib on OS X
-$(INCHI_LIB_PATHNAME).dylib$(VERSION): $(INCHI_LIB_OBJS)
-	$(SHARED_LINK) $(SHARED_LINK_PARM) -o $(INCHI_LIB_PATHNAME).dylib$(VERSION)	\
-$(INCHI_LIB_OBJS) -Wl$(LINUX_MAP)$(LINUX_Z_RELRO) -install_name $(INCHI_LIB_NAME).dylib$(VERSION) -lm
+$(INCHI_LIB_PATHNAME)$(VERSION).dylib: $(INCHI_LIB_OBJS)
+	$(SHARED_LINK) $(SHARED_LINK_PARM) -o $(INCHI_LIB_PATHNAME)$(VERSION).dylib	\
+$(INCHI_LIB_OBJS) -Wl$(LINUX_MAP)$(LINUX_Z_RELRO) -install_name $(INCHI_LIB_NAME)$(VERSION).dylib -lm
 else
 # djb-rwth: creating .so on Linux
 $(INCHI_LIB_PATHNAME).so$(VERSION): $(INCHI_LIB_OBJS)
