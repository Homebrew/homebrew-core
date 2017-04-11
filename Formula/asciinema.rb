class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://github.com/asciinema/asciinema/archive/v1.4.0.tar.gz"
  sha256 "841a55b0f51988d5e155e99badbd6ce5cf3b43cca2ba15cd20c971a19719dc9a"
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb083c12bf50fe56b223784cb761a6dcefd55cefaac138815912c85102c43153" => :sierra
    sha256 "e95c895bee1ee5c1f852e06522104489807510f157843ef10ea1d68a84318634" => :el_capitan
    sha256 "e95c895bee1ee5c1f852e06522104489807510f157843ef10ea1d68a84318634" => :yosemite
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
