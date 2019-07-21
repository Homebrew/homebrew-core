class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/4b/96/0e7c5c3de3dda4429ada9105fb695b54b6944e2cdbd29dc6fe857b05aa20/diffoscope-118.tar.gz"
  sha256 "14d63a69822388e2929126f241b8f034913296069b556266c0dc4597fab0a5ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c45d65dccc9d0167ebe953fd9203d41466d1e20ce6db92683dd4c013128a816" => :mojave
    sha256 "19cc737a9ddb989c4f6c40ceadf6b5cefe4faa7fd647f26c7eb8530432f09c7a" => :high_sierra
    sha256 "b6be2d7f61587345bf4c98effc79e88964cb2f9a09fb9defde8ef81ed3a17d12" => :sierra
  end

  depends_on "gnu-tar"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python"

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/b9/2c/c975b3410e148dab00d14471784a743268614e21121e50e4e00b13f38370/libarchive-c-2.8.tar.gz"
    sha256 "06d44d5b9520bdac93048c72b7ed66d11a6626da16d2086f9aad079674d8e061"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
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
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
