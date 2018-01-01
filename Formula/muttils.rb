class Muttils < Formula
  desc "Provides utilities for use with console mail clients, eg. Mutt"
  homepage "https://bitbucket.org/blacktrash/muttils/"
  url "https://bitbucket.org/blacktrash/muttils/get/1.3.tar.gz"
  sha256 "c8b456b660461441de8927ccff7e9f444894d6550d0777ed7bd160b8f9caddbf"
  head "https://bitbucket.org/blacktrash/muttils", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "cc13c555f3f6fe0527b1b2ef61f50d3e01fe99663d9ba76d8ea912c7114bb9f0" => :high_sierra
    sha256 "5c8920713f0a4abc1e6834dda10b40295010dfb96589196ffb319476801f3178" => :sierra
    sha256 "6843b7372098864c53199d84759724bcbf2c1ab36fc74c15e56405351e43fbc9" => :el_capitan
    sha256 "d976f7445a3142ff1c311cf19302b5fcc2976b0a26c0bb48e57e157bd4c7002f" => :yosemite
    sha256 "01f0c26274540336fa829a8718bb0c3a2a5b5aa3c96c1f4ec7cf79e6263b837b" => :mavericks
    sha256 "63e819c0bb96a56ed0f159ab816aeac84805a52333bd23298a17cd2abddcb17b" => :mountain_lion
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  conflicts_with "talk-filters", :because => "both install `wrap` binaries"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match /^foo\nbar\n$/, pipe_output("#{bin}/wrap -w 2", "foo bar")
  end
end
