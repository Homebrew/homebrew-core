class Mdbm < Formula
  desc "Y! MDBM a very fast memory-mapped key/value store"
  homepage "https://github.com/yahoo/mdbm/"
  url "https://github.com/yahoo/mdbm/archive/v4.13.0.tar.gz"
  sha256 "99cec32e02639048f96abf4475eb3f97fc669541560cd030992bab155f0cb7f8"

  depends_on "cppunit" => :build
  depends_on :xcode => ["10.2", :build]
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    ENV["DYLD_LIBRARY_PATH"] = libexec.to_s
    inreplace "Makefile.base" do |s|
      s.gsub! "INSTALL=ginstall", "INSTALL=install"
    end
    inreplace "gendoc/Makefile" do |s|
      s.gsub! "\$(INSTALL) -t \$(MAN_PREFIX)/man1 \$(shell find -L ./man/man1 -type f)", "\$(INSTALL) \$(shell find -L ./man/man1 -type f) \$(MAN_PREFIX)/man1"
    end
    inreplace "include/Makefile" do |s|
      s.gsub! "\$(INSTALL) -t \$(INC_PREFIX) \$(HEADERS)", "\$(INSTALL) \$(HEADERS) \$(INC_PREFIX)"
    end
    inreplace "src/tools/Makefile" do |s|
      s.gsub! "\$(INSTALL) -t \$(EXE_DEST) \$(EXES) \$(CPPEXES) \$(OBJDIR)/mdbm_bench \$(OBJDIR)/mash", \
              "\$(INSTALL) \$(EXES) \$(CPPEXES) \$(OBJDIR)/mdbm_bench \$(OBJDIR)/mash \$(EXE_DEST)"
    end
    inreplace "src/scripts/Makefile" do |s|
      s.gsub! "\$(INSTALL) -t \$(EXE_DEST) \$(SCRIPTS)", "\$(INSTALL) \$(SCRIPTS) \$(EXE_DEST)"
    end
    inreplace "src/java/Makefile" do |s|
      s.gsub! "\$(INSTALL) -D \$(OBJDIR)/\$(LIBNAME).\$(LIBVER) \$(LIB_DEST)", "\$(INSTALL) \$(OBJDIR)/\$(LIBNAME).\$(LIBVER) \$(LIB_DEST)"
    end
    inreplace "src/lib/Makefile" do |s|
      s.gsub! "LIB_DEST=\$(PREFIX)/lib\$(ARCH_SUFFIX)", "LIB_DEST=\$(PREFIX)/libexec"
      s.gsub! "\$(INSTALL) -D \$(OBJDIR)/\$(LIBNAME).\$(LIBVER) \$(LIB_DEST)", "\$(INSTALL) \$(OBJDIR)/\$(LIBNAME)\.\$(LIBVER) \$(LIB_DEST)"
    end

    system "make"
    Dir.glob("src/tools/object/*") do |f|
      next if ["mdbm_big_data_builder.pl", "mdbm_environment.sh", "mdbm_reset_all_locks"].include? File.basename(f)

      macho = MachO.open(f)
      macho.change_dylib("object/libmdbm.dylib", "#{libexec}/libmdbm.dylib")
      macho.write!
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ts_mdbm = testpath/"test.mdbm"
    system "mdbm_create", ts_mdbm
    assert_predicate ts_mdbm, :exist?
    system "mdbm_check", ts_mdbm
    system "mdbm_trunc", "-f", ts_mdbm
    system "mdbm_sync", ts_mdbm
  end
end
