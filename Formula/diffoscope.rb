class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories."
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/29/6d/704f5ab9ed92aa82f0bd796d12973e4aa3c13323e5843206297aa923aefd/diffoscope-67.tar.gz"
  sha256 "96f17de536f411e69d2944191a8860b5c8be22a7f5a6a5d4ea3d34cc94badbf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "c82b2fa62c50c2c3bf9e9fc76180260eb2e74271da3087831aa3861305b0a881" => :sierra
    sha256 "0ba46201e568d407d5950e8494eae43c1bb3e72926f707c416e8804392b4848a" => :el_capitan
    sha256 "0ba46201e568d407d5950e8494eae43c1bb3e72926f707c416e8804392b4848a" => :yosemite
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
    url "https://files.pythonhosted.org/packages/d8/94/4b2930f2146c1318e6250c85d884c87720f3089085e4d4ba53fa0f8c620c/python-magic-0.4.12.tar.gz"
    sha256 "a04b20900100884d4fce40a767182a16fcb9d10756c67cdc21f5fa610b7c9d3c"
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
