class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://0xacab.org/jvoisin/mat2/-/archive/0.12.0/mat2-0.12.0.tar.gz"
  sha256 "d2a7a4dd674b084fcd2a63d70cd132a36cea46d98626df3c9258f8327085baa0"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4fad5de836a909094672ce10f2de736f371ba6e075b2d2c89bd91f13a718772c" => :big_sur
    sha256 "f561dac02a6bf1c540295f9498d59bfa987c4f279d8a23ce546eee45fdc0c605" => :catalina
    sha256 "2bf3052ed3c51c5e77982c80904ad0599763125ad9dc31ccdd73ec1808a5ab05" => :mojave
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    pygobject3 = Formula["pygobject3"]
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"
    ENV.append_path "PYTHONPATH", pygobject3.opt_lib+"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mat2", "-l"
  end
end
