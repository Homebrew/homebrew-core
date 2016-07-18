class Frescobaldi < Formula
  desc "LilyPond sheet music text editor"
  homepage "http://frescobaldi.org/"
  url "https://github.com/wbsoft/frescobaldi/releases/download/v2.19.0/frescobaldi-2.19.0.tar.gz"
  sha256 "b426bd53d54fdc4dfc16fcfbff957fdccfa319d6ac63614de81f6ada5044d3e6"

  bottle do
    sha256 "6fdac72c8203c0585515a1bba8f36faea8b394a8852b258b7f630273c818b9e9" => :el_capitan
    sha256 "2b11cbd21fef365684ec0be8543a557fbc943ce9832b5c2b7b5204a081de74aa" => :yosemite
    sha256 "c592d71f41e66f3f5115c8eac982344fa903eff02a7e3a011852a5ee3e39d968" => :mavericks
    sha256 "cc6e9b3a940690ae225a157f4a0d95aec4db46f0ccf78442a99ae941f7a358a0" => :mountain_lion
  end

  option "with-lilypond", "Install Lilypond from Homebrew/tex"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "portmidi" => :optional
  depends_on "homebrew/tex/lilypond" => :optional

  # python-poppler-qt4 dependencies
  depends_on "pkg-config" => :build
  depends_on "poppler" => "with-qt"
  depends_on "pyqt"

  resource "python-poppler-qt4" do
    url "https://github.com/wbsoft/python-poppler-qt4/archive/v0.24.0.tar.gz"
    sha256 "164297bcb03dc0cd943342915bf49e678db13957ebc2f1f3bd988f04145fb236"
  end

  resource "python-ly" do
    url "https://files.pythonhosted.org/packages/57/4f/889579244947368f28eda66b782331b1e75f83fd72e63f9ece93cd7a18f9/python-ly-0.9.4.tar.gz"
    sha256 "c2f87999260af3c9ea00c9997dae1e596fac40f45905d8b7e24e0f441112d63c"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[python-poppler-qt4 python-ly].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    rm "setup.cfg"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    By default, a splash screen is shown on startup; this causes the main
    window not to show until the application icon on the dock is clicked
    (Cmd-Tab application switching does not appear to work).

    You may want to disable the splash screen in the preferences to
    solve this issue. See:
      https://github.com/wbsoft/frescobaldi/issues/428
  EOS
  end

  test do
    system bin/"frescobaldi", "--version"
  end
end
