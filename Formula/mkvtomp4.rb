class Mkvtomp4 < Formula
  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v2.0.tar.gz"
  sha256 "0f9aa1754d4b33a6a83c0a71a373836d4872b3288dae9cfb6168c35f09887f2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "feaa87d33fe714461c556ddb00b1dfdcab714abd57b04b500eb49e04cbf7f8fa" => :catalina
    sha256 "06b96194e09c4e952de56492047f83a6af1a173aba059ba9edd3ac2664e2cbf4" => :mojave
    sha256 "2efab72b382b03ac47c70b1878587afafdd8de2b7361d96f98e837692d5b4ca4" => :high_sierra
    sha256 "4c085a7e2cbfada2a722dc1d676fab80dacc1f490c14d2a2aff10a4fa60f5225" => :sierra
    sha256 "f7610334538d3e3df8cfeab0a5cd7d9a44acfb141212b4852e340064657e50a8" => :el_capitan
    sha256 "7ae6b5351e551f6f04811cc5b963fd67adc18132f9b4dc91fc07886f05b0d10f" => :yosemite
    sha256 "3346ab8be87d01200616db3887ed05d0d6693d2003ca4c3d5530c439ef732544" => :mavericks
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = lib+"python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib+"python#{xy}/site-packages"

    system "make"
    system "python3", *Language::Python.setup_install_args(prefix)

    bin.install "mkvtomp4.py" => "mkvtomp4"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
