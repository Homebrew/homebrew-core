class Pytouhou < Formula
  desc "Libre implementation of Touhou 6 engine"
  homepage "https://pytouhou.linkmauve.fr/"
  url "https://hg.linkmauve.fr/touhou", :revision => "5270c34b4c00", :using => :hg
  version "634"
  revision 5
  head "https://hg.linkmauve.fr/touhou", :using => :hg

  bottle do
    cellar :any
    sha256 "ec6da97347d1c1446f4c382ae8714db09270cb3dd19d875ded74e969c36ac53c" => :high_sierra
    sha256 "35f4e2d8fe6a8de9a0219ad246f667cf01b657f63c7e945163907585eab2830f" => :sierra
    sha256 "d3a4f33dbbdf0ebac641375f399ec2a35742ae04785b883a1c7c66952cf3dcd2" => :el_capitan
  end

  option "with-demo", "Install demo version of Touhou 6"

  depends_on "python"
  depends_on "pkg-config" => :build
  depends_on "libepoxy"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"
  depends_on "gtk+3" => :recommended
  if build.with? "gtk+3"
    depends_on "py3cairo"
    depends_on "pygobject3"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b3/ae/971d3b936a7ad10e65cb7672356cff156000c5132cf406cb0f4d7a980fd3/Cython-0.28.3.tar.gz"
    sha256 "1aae6d6e9858888144cea147eb5e677830f45faaff3d305d77378c3cba55f526"
  end

  resource "demo" do
    url "http://www16.big.or.jp/~zun/data/soft/kouma_tr013.lzh"
    sha256 "77ea64ade20ae7d890a4b0b1623673780c34dd2aa48bf2410603ade626440a8b"
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

    if build.with? "demo"
      resource("demo").stage do
        (pkgshare/"game").install Dir["東方紅魔郷　体験版/*"]
      end
    end

    # Set default game path to pkgshare
    inreplace "#{libexec}/bin/pytouhou", /('path'): '\.'/, "\\1: '#{pkgshare}/game'"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats
    s = <<~EOS
      The default path for the game data is:
        #{pkgshare}/game
    EOS
    if build.with? "demo"
      s += <<~EOS
        Demo version of Touhou 6 has been installed.
      EOS
    end
    s
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/pytouhou", "--help"
  end
end
