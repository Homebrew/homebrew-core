class Pytouhou < Formula
  desc "Libre implementation of Touhou 6 engine"
  homepage "https://pytouhou.linkmauve.fr/"
  url "https://hg.linkmauve.fr/touhou", :revision => "5270c34b4c00", :using => :hg
  version "634"
  revision 6
  head "https://hg.linkmauve.fr/touhou", :using => :hg

  bottle do
    cellar :any
    sha256 "da770fbd2301c23ee7a674866d6a7708359f29d4de0691b77f3b83d42ff32584" => :catalina
    sha256 "137b520306f3c5a3a2070c3c5741f8efcd7b057c91d364d754ad16ddb9e7408c" => :mojave
    sha256 "4e91f1ee4b708327308e1927f499d137bbb35589ab097743023cf6e0ae2cccb3" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "gtk+3"
  depends_on "libepoxy"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b3/ae/971d3b936a7ad10e65cb7672356cff156000c5132cf406cb0f4d7a980fd3/Cython-0.28.3.tar.gz"
    sha256 "1aae6d6e9858888144cea147eb5e677830f45faaff3d305d77378c3cba55f526"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # hg can't determine revision number (no .hg on the stage)
    inreplace "setup.py", /(version)=.+,$/, "\\1='#{version}',"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    # Set default game path to pkgshare
    inreplace "#{libexec}/bin/pytouhou", /('path'): '\.'/, "\\1: '#{pkgshare}/game'"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats
    <<~EOS
      The default path for the game data is:
        #{pkgshare}/game
    EOS
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/pytouhou", "--help"
  end
end
