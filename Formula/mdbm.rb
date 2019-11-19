class Mdbm < Formula
  desc "Y! MDBM a very fast memory-mapped key/value store"
  homepage "https://github.com/yahoo/mdbm/"
  url "https://github.com/yahoo/mdbm/archive/v4.13.0.tar.gz"
  sha256 "99cec32e02639048f96abf4475eb3f97fc669541560cd030992bab155f0cb7f8"

  depends_on "coreutils" => :build
  depends_on "cppunit" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def post_install
    mv @lib.to_s, @libexec.to_s, :force => true do
      ignored_extensions = [".sh", ".pl"]
      Dir.glob("#{bin}/*") do |file|
        next if ignored_extensions.include? File.extname(file)

        macho = MachO.open(file)
        macho.change_dylib("#{lib}/libmdbm.dylib", "#{libexec}/libmdbm.dylib")
        macho.write!
      end
    end
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
