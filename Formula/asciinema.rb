class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/v1.3.0.tar.gz"
  sha256 "968016828119d53b8e4e6ccf40a2635704d236f8e805f635c15adc09a4373a55"

  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaba59c7528f909f665ae4150f9c21d87b818244aefa176ad5ccba1469c33a4c" => :sierra
    sha256 "6205d485d86ea24d0a0396cc56fd76b09490a83c5210e74ff505aa03cd4fcb1d" => :el_capitan
    sha256 "6578e8f11c7d2918f1f7a6c00350c485a937ae1a7037e4d715ecf66e80001cd7" => :yosemite
    sha256 "25455ff63f3f68f17671727ba02f09bb7b03bfa4fadab3fa0c9bd4a7d687cbf0" => :mavericks
  end

  depends_on :python3

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
