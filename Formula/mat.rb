class Mat < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://mat.boum.org/"
  url "https://mat.boum.org/files/mat-0.6.1.tar.xz"
  sha256 "0782e7db554ad1dddefd71c9c81e36a05464d73ab54ee2a474ea6ac90e8e51b9"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "564d84f0aa5dcce93fca87d91859cc87afbea8d9f915e4cc235117aa0f196d05" => :mojave
    sha256 "b283b291b6bf2c328a5c47c0eff442eb757575e3572071ec17ee7aed5e8e39e7" => :high_sierra
    sha256 "e03173ae8fc422f595f67c2b878e4e984592b0fa0aba15b1bf1138e8e37c6839" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "coreutils"
  depends_on "poppler"
  depends_on "py2cairo"
  depends_on "pygobject3" => "with-python@2"

  resource "hachoir-core" do
    url "https://files.pythonhosted.org/packages/source/h/hachoir-core/hachoir-core-1.3.3.tar.gz"
    sha256 "ecf5d16eccc76b22071d6062e54edb67595f70d827644d3a6dff04289b4058df"
  end

  resource "hachoir-parser" do
    url "https://files.pythonhosted.org/packages/source/h/hachoir-parser/hachoir-parser-1.3.4.tar.gz"
    sha256 "775be5e10d72c6122b1ba3202dfce153c09ebcb60080d8edbd51aa89aa4e6b3f"
  end

  resource "pdfrw" do
    url "https://files.pythonhosted.org/packages/source/p/pdfrw/pdfrw-0.2.tar.gz"
    sha256 "09f734df28f9ad712a2c14308b1d60e7202762c3ce2e32a6ad30e7ec149822b2"
  end

  resource "distutils-extra" do
    url "https://launchpad.net/python-distutils-extra/trunk/2.38/+download/python-distutils-extra-2.38.tar.gz"
    sha256 "3d100d5d3492f40b3e7a6a4500f71290bfa91e2c50dc31ba8e3ff9b5d82ca153"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/source/m/mutagen/mutagen-1.31.tar.gz"
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
