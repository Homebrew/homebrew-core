class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://files.pythonhosted.org/packages/d5/e4/f02d057fe6cf32b68e402c5f86276244105da40161e84ef785b2ae0bf809/mat2-0.13.4.tar.gz"
  sha256 "744aeee924c9898a397fe930593b803c540389bf39cd24553b99a89acc2f5901"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "592b41922c9a703cf1bf672b2da4d181957e790334780d3c6326727368fd727a"
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

  # patch man1 file layout, remove in next release
  # https://0xacab.org/jvoisin/mat2/-/merge_requests/111
  patch do
    url "https://0xacab.org/jvoisin/mat2/-/commit/406924bb6164384fe0a8a8f3dc8dfe7d15577cfc.diff"
    sha256 "4c1c57ca8fe1eabea41d66f3ef9bd4eb2bac8ac181fceeefece4b92b5be9658d"
  end

  def install
    python = "python3.11"

    ENV.append_path "PYTHONPATH", prefix/Language::Python.site_packages(python)
    ENV.append_path "PYTHONPATH", Formula["pygobject3"].opt_prefix/Language::Python.site_packages(python)
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python)

    resources.each do |r|
      r.stage do
        system python, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), "."
      end
    end

    system python, "-m", "pip", "install", *std_pip_args, "."
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"mat2", "-l"
  end
end
