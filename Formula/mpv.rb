class Mpv < Formula
  desc "Free, open source, and cross-platform media player"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.18.1.tar.gz"
  sha256 "e413d57fec4ad43b9f9b848f38d13fb921313fc9a4a64bf1e906c8d0f7a46329"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    revision 1
    sha256 "031c195541d3ea51f8b5032a6d2fdc8065e036e542e1317cd01d5ca0ffcf1b6a" => :el_capitan
    sha256 "f794fe2ea44783c77579b8aa651b94939419929f2f87b46af31a97b2e6483119" => :yosemite
    sha256 "95f7fb3e9afdc606fc0199cbe60f81e20987af7c7dd071c4dcfb66a620fea168" => :mavericks
  end

  option "with-bundle", "Enable compilation of the .app bundle."

  depends_on "pkg-config" => :build
  depends_on :python3

  depends_on "libass"
  depends_on "ffmpeg"

  depends_on "jpeg" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "lua" => :recommended
  depends_on "youtube-dl" => :recommended

  depends_on "libarchive" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libdvdnav" => :optional
  depends_on "libbluray" => :optional
  depends_on "libaacs" => :optional
  depends_on "vapoursynth" => :optional
  depends_on "uchardet" => :optional
  depends_on :x11 => :optional

  depends_on :macos => :mountain_lion

  resource "waf" do
    url "https://waf.io/waf-1.9.1"
    sha256 "8c71b0372a4bea1c02e2ff5e1aa52484ab9d2e81076538be2cda4e85498d7021"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  def install
    # LANG is unset by default on osx and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    version = Language::Python.major_minor_version("python3")
    ENV.prepend_create_path "PKG_CONFIG_PATH", Pathname.new(`python3-config --prefix`.chomp)/"lib/pkgconfig"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PATH", libexec/"bin"
    resource("docutils").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    args = %W[
      --prefix=#{prefix}
      --enable-zsh-comp
      --enable-libmpv-shared
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
    ]
    args << "--enable-libarchive" if build.with? "libarchive"

    waf = resource("waf")
    buildpath.install waf.files("waf-#{waf.version}" => "waf")
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"

    if build.with? "bundle"
      system "python3", "TOOLS/osxbundle.py", "build/mpv"
      prefix.install "build/mpv.app"
    end
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
