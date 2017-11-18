class Mat < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://mat.boum.org/"
  url "https://mat.boum.org/files/mat-0.6.1.tar.xz"
  sha256 "0782e7db554ad1dddefd71c9c81e36a05464d73ab54ee2a474ea6ac90e8e51b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "3619ba5bc1b37cc63500864f6bb7aa0f124c8e9039640f94d464796d1b7f8f65" => :high_sierra
    sha256 "7d4635e0a5ba485e170331015408512caf7f3de11bfe66e739ad8abe288add6d" => :sierra
    sha256 "bcd1ab8ac5dfef8d65e0c0b361314a5df7e178efb556b02983fda2149cada310" => :el_capitan
    sha256 "a0cfbbe2c51f0310fcfd61c4ae97bc5e10738216bd2904b367c913d49377c467" => :yosemite
  end

  depends_on :python => :optional
  depends_on "coreutils"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "exiftool" => :optional
  depends_on "gettext" => :build
  depends_on "intltool" => :build

  resource "hachoir-core" do
    url "https://pypi.python.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha256 "ecf5d16eccc76b22071d6062e54edb67595f70d827644d3a6dff04289b4058df"
  end

  resource "hachoir-parser" do
    url "https://pypi.python.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha256 "775be5e10d72c6122b1ba3202dfce153c09ebcb60080d8edbd51aa89aa4e6b3f"
  end

  resource "pdfrw" do
    url "https://pypi.python.org/packages/source/p/pdfrw/pdfrw-0.2.tar.gz"
    sha256 "09f734df28f9ad712a2c14308b1d60e7202762c3ce2e32a6ad30e7ec149822b2"
  end

  resource "distutils-extra" do
    url "https://launchpad.net/python-distutils-extra/trunk/2.38/+download/python-distutils-extra-2.38.tar.gz"
    sha256 "3d100d5d3492f40b3e7a6a4500f71290bfa91e2c50dc31ba8e3ff9b5d82ca153"
  end

  resource "mutagen" do
    url "https://pypi.python.org/packages/source/m/mutagen/mutagen-1.31.tar.gz"
    sha256 "0aa011707785fe30935d8655380052a20ba8b972aa738d4f144c457b35b4d699"
  end

  def install
    pygobject3 = Formula["pygobject3"]
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.append_path "PYTHONPATH", pygobject3.opt_lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    %w[hachoir-core hachoir-parser pdfrw distutils-extra mutagen].each do |r|
      resource(r).stage do
        pyargs = ["setup.py", "install", "--prefix=#{libexec}"]
        unless %w[hachoir-core hachoir-parser pdfrw mutagen].include? r
          pyargs << "--single-version-externally-managed" << "--record=installed.txt"
        end
        system "python", *pyargs
      end
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    # Since we don't support it let's remove the GUI binary.
    rm bin/"mat-gui"
    man1.install Dir["*.1"]

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats
    <<~EOS
      MAT was built without PDF support nor GUI.
    EOS
  end

  test do
    system "#{bin}/mat", "-l"
    touch "foo"
    system "tar", "cf", "foo.tar", "foo"
    system "#{bin}/mat", "-c", "foo.tar"
  end
end
