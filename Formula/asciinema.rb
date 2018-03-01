class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://dl.bintray.com/homebrew/mirror/asciinema-2.0.0.tar.gz"
  mirror "https://github.com/asciinema/asciinema/archive/v2.0.0.tar.gz"
  sha256 "65224d8dcc8c579fd678fff83ea89eecfd35a1d2ca853ee6fcf27d2f7b5e3205"
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "008da09fe041e574a6a00d20467b8e071e91e32dc152be6e1d65f5868c17f230" => :high_sierra
    sha256 "008da09fe041e574a6a00d20467b8e071e91e32dc152be6e1d65f5868c17f230" => :sierra
    sha256 "008da09fe041e574a6a00d20467b8e071e91e32dc152be6e1d65f5868c17f230" => :el_capitan
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
