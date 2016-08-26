class Mpv < Formula
  desc "Free, open source, and cross-platform media player"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.19.0.tar.gz"
  sha256 "3df5811942cd1d71f48eb4720092fdafec11885bf6dd6d1d3e6413f32e5d67e2"
  revision 1
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "d92ae05eaed8de80633a748b7dc4911d20d0cacc395d39391e7b84b8a850a38f" => :el_capitan
    sha256 "8e6b633c6f25018e7b4ab18178fa5871aa99adf154bcf757c31b45b3cfdd80a0" => :yosemite
    sha256 "0503556270534ad7b4fd7fbe0b3ea96ffc1dbe8e1bed3bba40a373d9dd6637c3" => :mavericks
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
    url "https://waf.io/waf-1.9.2"
    sha256 "7abb4fbe61d12b8ef6a3163653536da7ee31709299d8f17400d71a43247cea81"
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
