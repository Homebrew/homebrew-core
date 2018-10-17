class Choose < Formula
  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  revision 1
  head "https://github.com/geier/choose.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dba7080c2cbfec86cece9b777e0e8bbddc978d9d16869d8c40dedca3db5fa2f7" => :mojave
    sha256 "0798c4a91ff53f4ab075f9509c20fa40c809d7d692be156089e934673a6d73f8" => :high_sierra
    sha256 "9a91c98c4f1ff7d3a639e324d7926d39b21fca78cb32d2ef153510ac8d2306e1" => :sierra
  end

  depends_on "python"

  conflicts_with "choose-gui", :because => "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
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
