class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  license "MIT"
  revision 3
  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "108d84aff61c4374011202cab8203770cdee57c0445ad40735c1f41513140606" => :big_sur
    sha256 "c8408b41107e7824596b3c28b2f63f98c910a7452ff676805a7ec5e77ba505bc" => :arm64_big_sur
    sha256 "086ebca8f9bff4d065e788c9076bfe204b958f96b8da0cce142f3c890c38cb75" => :catalina
    sha256 "bef5f7490cf4a45398bfdef4867163957675227e74bab1494ea0da56cda2cda6" => :mojave
    sha256 "f860816e00292d161ed6f6617cef47c3297eb91e9231f3c125ce12b16ad7d220" => :high_sierra
  end

  depends_on "python@3.9"

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
