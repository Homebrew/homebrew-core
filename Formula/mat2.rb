class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://0xacab.org/jvoisin/mat2/-/archive/0.13.0/mat2-0.13.0.tar.gz"
  sha256 "8f895b45247c701f311da52442de7d1117cce234f82936edf305d6e339c016b0"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e3081b97a1b9374ddaf5efccf1ab643202d6ebcdf08dd179ae329cc4736c72a"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.10"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  def install
    python = "python3.10"

    ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)
    ENV.append_path "PYTHONPATH", Formula["pygobject3"].opt_prefix/Language::Python.site_packages(python)
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python)

    resources.each do |r|
      r.stage do
        system python, *Language::Python.setup_install_args(libexec/"vendor", python), "--install-data=#{prefix}"
      end
    end

    system python, *Language::Python.setup_install_args(prefix, python)
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"mat2", "-l"
  end
end
