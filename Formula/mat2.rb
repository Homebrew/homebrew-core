class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://0xacab.org/jvoisin/mat2/-/archive/0.12.1/mat2-0.12.1.tar.gz"
  sha256 "5f1cf47c61cc137b5a3d0520c4d4db27706b045f2425ee3837148b2397a26e65"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2cf257a8aaf56858e195df29823cb3fdef6b25deb2c7df0a19d17e02044bfc05"
    sha256 cellar: :any_skip_relocation, catalina: "6134535ba8f2fd9b654df05cb0398eb167140ff636e8988228791102227695c0"
    sha256 cellar: :any_skip_relocation, mojave:   "130e341149d1005c85efc2b5421b133f8897b98913b27186ef1360c3de138726"
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
