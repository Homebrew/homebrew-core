class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/v2.0.2.tar.gz"
  sha256 "2578a1b5611e5375771ef6582a6533ef8d40cdbed1ba1c87786fd23af625ab68"
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7567533cadf48707d06bc0b02b3020d2b4fb951abc7875f90ec4a63be484cbd" => :catalina
    sha256 "0181fd73b18e9ce96149b5751f12dd15ac7fd7e6c03405cbf7f99ae5b64b6419" => :mojave
    sha256 "29bd540035a1382c6a92e6fb8d47ca909694867c543a456b3f45c5a1ee319aec" => :high_sierra
    sha256 "29bd540035a1382c6a92e6fb8d47ca909694867c543a456b3f45c5a1ee319aec" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/asciinema", "--version"
    system "#{bin}/asciinema", "--help"
  end
end
