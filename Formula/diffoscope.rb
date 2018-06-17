class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/4d/63/e6c1ac907f7eef81b5c53b07b0734e3f654a64d2302b86f47025a7b0d362/diffoscope-96.tar.gz"
  sha256 "e2d067f540e11aa690f546bed1cafa8081a3d97d1192e05c7cc3c78aba70c6f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbd95ea93b3b48e9e4cba0cc8456f855b7ae5414c2bcfa6770b17f432873d478" => :high_sierra
    sha256 "dbd95ea93b3b48e9e4cba0cc8456f855b7ae5414c2bcfa6770b17f432873d478" => :sierra
    sha256 "dbd95ea93b3b48e9e4cba0cc8456f855b7ae5414c2bcfa6770b17f432873d478" => :el_capitan
  end

  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "gnu-tar"
  depends_on "python"

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/b9/2c/c975b3410e148dab00d14471784a743268614e21121e50e4e00b13f38370/libarchive-c-2.8.tar.gz"
    sha256 "06d44d5b9520bdac93048c72b7ed66d11a6626da16d2086f9aad079674d8e061"
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
