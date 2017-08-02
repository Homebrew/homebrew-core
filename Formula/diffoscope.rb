class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories."
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/48/d6/58af768acee19ae1a5e8799673e7a2cb6649feab5dee1013cae38a343f19/diffoscope-85.tar.gz"
  sha256 "370070197ec0c313963ba81b225e3e0dfd0d51a494a796df1267cfb5c9762ad6"

  bottle do
    cellar :any_skip_relocation
    sha256 "aebd26ee5e903380ef3c160de1d7bba026830ff32948fe7b5f6c4f469b33dc6b" => :sierra
    sha256 "aebd26ee5e903380ef3c160de1d7bba026830ff32948fe7b5f6c4f469b33dc6b" => :el_capitan
    sha256 "aebd26ee5e903380ef3c160de1d7bba026830ff32948fe7b5f6c4f469b33dc6b" => :yosemite
  end

  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "gnu-tar"
  depends_on :python3

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/1f/4a/7421e8db5c7509cf75e34b92a32b69c506f2b6f6392a909c2f87f3e94ad2/libarchive-c-2.7.tar.gz"
    sha256 "56eadbc383c27ec9cf6aad3ead72265e70f80fa474b20944328db38bab762b04"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/65/0b/c6b31f686420420b5a16b24a722fe980724b28d76f65601c9bc324f08d02/python-magic-0.4.13.tar.gz"
    sha256 "604eace6f665809bebbb07070508dfa8cabb2d7cb05be9a56706c60f864f1289"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    libarchive = Formula["libarchive"].opt_lib/"libarchive.dylib"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"],
                                            :LIBARCHIVE => libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "test1", "test2"
  end
end
