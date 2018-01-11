class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/6c/b7/a5f5f5fb994fa8230769a6e211b9306e0882d0158744c168f7bb694a6f26/diffoscope-90.tar.gz"
  sha256 "d1507e40bc7a920cbfb9df6f69029e84ad084d9804733af923587c10b7110f42"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "028eb76552bcd1d770c4e0c8d68ba9510e9879573791b00635f7a3a64493f8ab" => :high_sierra
    sha256 "028eb76552bcd1d770c4e0c8d68ba9510e9879573791b00635f7a3a64493f8ab" => :sierra
    sha256 "028eb76552bcd1d770c4e0c8d68ba9510e9879573791b00635f7a3a64493f8ab" => :el_capitan
  end

  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "gnu-tar"
  depends_on "python3"

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/1f/4a/7421e8db5c7509cf75e34b92a32b69c506f2b6f6392a909c2f87f3e94ad2/libarchive-c-2.7.tar.gz"
    sha256 "56eadbc383c27ec9cf6aad3ead72265e70f80fa474b20944328db38bab762b04"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/84/30/80932401906eaf787f2e9bd86dc458f1d2e75b064b4c187341f29516945c/python-magic-0.4.15.tar.gz"
    sha256 "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5"
  end

  def install
    ENV.delete("PYTHONPATH") # play nice with libmagic --with-python

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
