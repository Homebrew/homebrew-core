class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories."
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/72/76/5c44c30c4ab43f4f711941a3e89aff8157d51238db3457a1f7adfe89cb56/diffoscope-84.tar.gz"
  sha256 "7a8e6a2bd3562fa650cad90f4c9a3ec9b070d5a2e55d437f5f28a8a07aecd53f"

  bottle do
    cellar :any_skip_relocation
    sha256 "234667032522deb6ba85406226b0ed9855db88d4a688197be1d3e79b95e7228c" => :sierra
    sha256 "1becb2f15dbc9cfa42eca1816302bc3f4cedd58e1f28f762d5a833600b3ccd05" => :el_capitan
    sha256 "1becb2f15dbc9cfa42eca1816302bc3f4cedd58e1f28f762d5a833600b3ccd05" => :yosemite
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
