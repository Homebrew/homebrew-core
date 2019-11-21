class Mdbm < Formula
  desc "Y! MDBM a very fast memory-mapped key/value store"
  homepage "https://github.com/yahoo/mdbm/"
  url "https://github.com/yahoo/mdbm/archive/v4.13.0.tar.gz"
  sha256 "99cec32e02639048f96abf4475eb3f97fc669541560cd030992bab155f0cb7f8"

  depends_on "coreutils" => :build
  depends_on "cppunit" => :build
  depends_on :xcode => ["10.2", :build]
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    ENV["DYLD_LIBRARY_PATH"] = libexec.to_s
    inreplace "src/lib/Makefile" do |s|
      s.gsub! "LIB_DEST=\$(PREFIX)/lib\$(ARCH_SUFFIX)", "LIB_DEST=\$(PREFIX)/libexec"
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
