class Diffoscope < Formula
  desc "In-depth comparison of files, archives, and directories."
  homepage "https://diffoscope.org"
  url "https://pypi.python.org/packages/source/d/diffoscope/diffoscope-42.tar.gz"
  sha256 "c0241acf5de7eb0e9e209e43dbf389beca722ddfb8b5d5630fd40569f1f465e2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b6e20aa50502b90c3452eb1718d359fe6cd6cb587c44e1c54b40b8d13159abc3" => :sierra
    sha256 "b6e20aa50502b90c3452eb1718d359fe6cd6cb587c44e1c54b40b8d13159abc3" => :el_capitan
    sha256 "b6e20aa50502b90c3452eb1718d359fe6cd6cb587c44e1c54b40b8d13159abc3" => :yosemite
  end

  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "gnu-tar"
  depends_on :python3

  patch do
    # Patch for legacy diff(1)
    # https://anonscm.debian.org/cgit/reproducible/diffoscope.git/patch/?id=261be7
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ebbff7b/diffoscope/patch-legacy-diff.diff"
    sha256 "aeaffa34a774e05477c9ef78df35174b006670b2963b9064c9c4c13484825b0b"
  end

  resource "libarchive-c" do
    url "https://pypi.python.org/packages/source/l/libarchive-c/libarchive-c-2.2.tar.gz"
    sha256 "5d54aa6f6ab21e3bd12c2f8b6c4e80316b049c2b60ab0a4418cb34d8c63e997c"
  end

  resource "python-magic" do
    url "https://pypi.python.org/packages/source/p/python-magic/python-magic-0.4.10.tar.gz"
    sha256 "79fd2865ec96074749825f9e9562953995d5bf12b6793f24d75c37479ad4a2c3"
  end

  def install
    inreplace "diffoscope/comparators/tar.py", "'tar'", "'gtar'"

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
