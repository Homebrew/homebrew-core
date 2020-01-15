class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  revision 2
  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ab4073c8ee6edfe6d8755faa1a3b40b086de12f9c4bba2054de3dbdda68513c" => :catalina
    sha256 "15cf39919e08f33252dd110f7c2d61ece1865bfbf1d32041f57b491fb7ccbb1d" => :mojave
    sha256 "61defb32c37bb7d6c152043f6602d0abd1cbc8aac25fe2fa888e1905fe68ba85" => :high_sierra
  end

  depends_on "python@3.8"

  conflicts_with "choose-gui", :because => "both install a `choose` binary"

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

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # There isn't really a better test than that the executable exists
    # and is executable because you can't run it without producing an
    # interactive selection ui.
    assert_predicate bin/"choose", :executable?
  end
end
