class EyeD3 < Formula
  desc "Work with ID3 metadata in .mp3 files"
  homepage "http://eyed3.nicfit.net/"
  url "http://eyed3.nicfit.net/releases/eyeD3-0.8.1.tar.gz"
  sha256 "a982eccb220c54e9ca5eb2467a3eb11082b6fb962f0fec58fd9b555397208998"

  bottle do
    cellar :any_skip_relocation
    sha256 "d30bae548e263335a40ad66134deb0b9ebd2fb64c063f046b3e5b7d15b8bce45" => :sierra
    sha256 "acfb35d236229963feeed7e2ad301c96dbcc381d5320e4346b3da44cb35c7b6a" => :el_capitan
    sha256 "a79293b1de717fa855e7adfbadb4570a52331f8ef6297f7f1b8a514edd1eea10" => :yosemite
    sha256 "1ed297626268da26de4ca3b1f4e1a2bb6302b1dc7716271775070a6660eb6142" => :mavericks
    sha256 "68c255648b6bca4542ee041122e96f276611cdc3785a4016c658c61d877d9419" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libmagic"

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  resource "pathlib" do
    url "https://files.pythonhosted.org/packages/ac/aa/9b065a76b9af472437a0059f77e8f962fe350438b927cb80184c32f075eb/pathlib-1.0.1.tar.gz"
    sha256 "6940718dfc3eff4258203ad5021090933e5c04707d5ca8cc9e73c94a7894ea9f"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/65/0b/c6b31f686420420b5a16b24a722fe980724b28d76f65601c9bc324f08d02/python-magic-0.4.13.tar.gz"
    sha256 "604eace6f665809bebbb07070508dfa8cabb2d7cb05be9a56706c60f864f1289"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Install in our prefix, not the first-in-the-path python site-packages dir.
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    share.install "docs/plugins", "docs/cli.rst"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "temp.mp3"
    system "#{bin}/eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
