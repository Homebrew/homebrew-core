class Mkvtomp4 < Formula
  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v2.0.tar.gz"
  sha256 "0f9aa1754d4b33a6a83c0a71a373836d4872b3288dae9cfb6168c35f09887f2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d191cf2f5a132c6783cf35a8fb74cb4a8c1c787d07149181f81b2f258172198" => :catalina
    sha256 "5d191cf2f5a132c6783cf35a8fb74cb4a8c1c787d07149181f81b2f258172198" => :mojave
    sha256 "5d191cf2f5a132c6783cf35a8fb74cb4a8c1c787d07149181f81b2f258172198" => :high_sierra
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
