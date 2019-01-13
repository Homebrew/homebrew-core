class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/v2.0.2.tar.gz"
  sha256 "2578a1b5611e5375771ef6582a6533ef8d40cdbed1ba1c87786fd23af625ab68"
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5beedf1dd255d1bc2793aee0d5ed024730f2c9162b4fa52680311371d0c9c11" => :mojave
    sha256 "7673916f20d752ad61c5bc859fef8d5a4baec23e684b1bff0363fac3e789ae68" => :high_sierra
    sha256 "7673916f20d752ad61c5bc859fef8d5a4baec23e684b1bff0363fac3e789ae68" => :sierra
    sha256 "7673916f20d752ad61c5bc859fef8d5a4baec23e684b1bff0363fac3e789ae68" => :el_capitan
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
