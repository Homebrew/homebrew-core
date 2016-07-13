class Asciinema < Formula
  desc "Record and share terminal sessions"
  homepage "https://asciinema.org/"
  url "https://files.pythonhosted.org/packages/06/96/93947d9be78aebb7985014fdf4d84896dd0f62514d922ee03f5bb55a21fb/asciinema-1.3.0.tar.gz"
  sha256 "acc1a07306c7af02cd9bc97c32e4748dbfa57ff11beb17fea64eaee67eaa2db3"
  head "https://github.com/asciinema/asciinema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a912cac0c3f63fdf3e102cbde0b1a42895c80d176f9bb9116a00f3835b5d9260" => :el_capitan
    sha256 "845f9ac6d0a94b7938583baf12485edc678334d7ce3758a629f76eeabac99e1f" => :yosemite
    sha256 "b92022ad9a785aebbedc1cbd19160eba65416070dea34f5cb8d5d2de7e6d0315" => :mavericks
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
    assert_match version.to_s, shell_output("#{bin}/asciinema --version")
  end
end
