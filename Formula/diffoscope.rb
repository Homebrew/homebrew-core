class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/3a/3e/308a04b435a6c8c9956656b7f2a66d6ed38d5972df453d70202834c4ff43/diffoscope-98.tar.gz"
  sha256 "7863d56a3ca3bce9dd206e8b1a6199dda464df92e051a9b475e2e3093cfbf472"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e09b5d1eeed2fbcfd22d8ac7ae15e241ebef876a497c680542c728067ce277a" => :high_sierra
    sha256 "3e09b5d1eeed2fbcfd22d8ac7ae15e241ebef876a497c680542c728067ce277a" => :sierra
    sha256 "3e09b5d1eeed2fbcfd22d8ac7ae15e241ebef876a497c680542c728067ce277a" => :el_capitan
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
