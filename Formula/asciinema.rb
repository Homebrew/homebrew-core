class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/v1.4.0.tar.gz"
  sha256 "841a55b0f51988d5e155e99badbd6ce5cf3b43cca2ba15cd20c971a19719dc9a"
  revision 1
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c87255dfbc081c753105dc317b5b0469b91bdf8804895deb23bbebc82fe42836" => :high_sierra
    sha256 "c87255dfbc081c753105dc317b5b0469b91bdf8804895deb23bbebc82fe42836" => :sierra
    sha256 "c87255dfbc081c753105dc317b5b0469b91bdf8804895deb23bbebc82fe42836" => :el_capitan
  end

  depends_on "python3"

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
