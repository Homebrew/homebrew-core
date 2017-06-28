class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories."
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/44/23/dabf575ea14c723ca01759738c6857f5de42d55cd5a458277264a7ddc31c/diffoscope-82.tar.gz"
  sha256 "e90c5d99a7c750c1f2c8baa5a34c8f2640d79d9c0837b8e10831bbc8ad350637"

  bottle do
    cellar :any_skip_relocation
    sha256 "8433aa5e2a048b8a79b35dc8ada9ea52f76084cc2d734ff0505add96d349b4f5" => :sierra
    sha256 "a8624f901191e616aeb1553a54fdd56ae7fb66123beade667b2612b4febe9879" => :el_capitan
    sha256 "a8624f901191e616aeb1553a54fdd56ae7fb66123beade667b2612b4febe9879" => :yosemite
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
