class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://0xacab.org/jvoisin/mat2/-/archive/0.10.1/mat2-0.10.1.tar.gz"
  sha256 "5ed3d9c945d1475479a42e87879821440c66c2881db157aa480ccdcefc13d202"

  bottle do
    cellar :any_skip_relocation
    sha256 "f76a7502c9fe7004b93005da64beee98ccc56312be9e228411ca1e2a94aa8771" => :catalina
    sha256 "f76a7502c9fe7004b93005da64beee98ccc56312be9e228411ca1e2a94aa8771" => :mojave
    sha256 "f76a7502c9fe7004b93005da64beee98ccc56312be9e228411ca1e2a94aa8771" => :high_sierra
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/30/4c/5ad1a6e1ccbcfaf6462db727989c302d9d721beedd9b09c11e6f0c7065b0/mutagen-1.42.0.tar.gz"
    sha256 "bb61e2456f59a9a4a259fbc08def6d01ba45a42da8eeaa97d00633b0ec5de71c"
  end

  def install
    inreplace "libmat2/exiftool.py", "/usr/bin/exiftool", "#{Formula["exiftool"].opt_bin}/exiftool"
    inreplace "libmat2/video.py", "/usr/bin/ffmpeg", "#{Formula["ffmpeg"].opt_bin}/ffmpeg"

    version = Language::Python.major_minor_version("python3")
    pygobject3 = Formula["pygobject3"]
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
    ENV.append_path "PYTHONPATH", pygobject3.opt_lib+"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mat2", "-l"
  end
end
