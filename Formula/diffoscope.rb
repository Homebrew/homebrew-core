class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/8d/e7/b8881e47097497471c7112ef2abc4328496f66e5c91772837ef365f39dc1/diffoscope-99.tar.gz"
  sha256 "9d204ac51cc8ae59de755e1be0f7600e52b59badc32969942af4684c3f6f3f03"

  bottle do
    cellar :any_skip_relocation
    sha256 "a73bcac36a13c0fe57649aa74d4c732d747beea812ff8530edfc23f75013b025" => :high_sierra
    sha256 "a73bcac36a13c0fe57649aa74d4c732d747beea812ff8530edfc23f75013b025" => :sierra
    sha256 "a73bcac36a13c0fe57649aa74d4c732d747beea812ff8530edfc23f75013b025" => :el_capitan
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
