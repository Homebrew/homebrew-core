class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  license "MIT"
  revision 2
  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "add76ddd5165ad17bfc784dff7237777eac7ee898379bd55d76228e6f6897d6d" => :catalina
    sha256 "74170f2582ab4a29bffcc34583017f97f39c5b600a5f5cfebacd6d66ecd5c818" => :mojave
    sha256 "388b64e8072a54f01006ab9cad297789eda36fe0bec83b45759cfe80dbf8cb2c" => :high_sierra
  end

  depends_on "python@3.8"

  conflicts_with "choose-gui", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    resource("urwid").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    bin.install "choose"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    assert_predicate bin/"choose", :executable?
  end
end
