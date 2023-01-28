class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://0xacab.org/jvoisin/mat2/-/archive/0.13.2/mat2-0.13.2.tar.gz"
  sha256 "957633dd80b0c060062925b057607559bdcd9a52fbe25bee0723d1db425dffaf"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80e769c1d7702ec07cce85816cceecaaaab97b65b123dd7477b984a42739b956"
  end

  depends_on "exiftool"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "librsvg"
  depends_on "poppler"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  def install
    python = "python3.11"

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
