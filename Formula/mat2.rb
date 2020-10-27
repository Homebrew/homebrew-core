class Mat2 < Formula
  desc "Metadata anonymization toolkit"
  homepage "https://0xacab.org/jvoisin/mat2"
  url "https://0xacab.org/jvoisin/mat2/-/archive/0.11.0/mat2-0.11.0.tar.gz"
  sha256 "c37be119f4bc6226257cd72048bba4eaf3bb24a62fd38c2a34d9b937e6bd36b7"
  license "LGPL-3.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c00bf22997c1d5e511168f1bff739c6716241df686b2229d33367345b8fa1016" => :catalina
    sha256 "60d05ad4b03e6bcf95eb2dd1abc94ff9d3e0a1c1e5d89c524b865735c070dbe0" => :mojave
    sha256 "5cf8c273912d903c1c4502f197b2d4d032954bb3c563b8e2563ea8f9ac2173f8" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/96/9f/280220926cabbf4822f80e094a5190fb3df245209648e169c8bcf708697b/mutagen-1.44.0.tar.gz"
    sha256 "56065d8a9ca0bc64610a4d0f37e2bd4453381dde3226b8835ee656faa3287be4"
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
