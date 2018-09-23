class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/24/28/057571b62db9f0b640f4fcd101c7975382921d7d0596410ea0c461a93cc2/diffoscope-102.tar.gz"
  sha256 "a632d851a8aa8d0858bc84d8173c5425c7b42e7503612f028f9bd8d33b4a5f6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "65daa58c325c633a0c405706e86887f8cf89aaadf28166116208381f8ca5e797" => :mojave
    sha256 "07046b82f51513157e08f0613946e6d8f09a3a82ab937b40e6a4480b65b4f8e4" => :high_sierra
    sha256 "07046b82f51513157e08f0613946e6d8f09a3a82ab937b40e6a4480b65b4f8e4" => :sierra
    sha256 "07046b82f51513157e08f0613946e6d8f09a3a82ab937b40e6a4480b65b4f8e4" => :el_capitan
  end

  depends_on "gnu-tar"
  depends_on "libarchive"
  depends_on "libmagic"
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
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"],
                                            :LIBARCHIVE => libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "test1", "test2"
  end
end
