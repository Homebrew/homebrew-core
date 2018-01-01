class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.16.tar.gz"
  sha256 "d50a19be1c6a5b6a777ddfb4abbc6c76a361b3edce266f1618947ad38a100331"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d1cc4fb525c44c885f69c02d49f314e95d1a0c439e00266b5f514e8a5233c4d" => :high_sierra
    sha256 "c441d37b9dd7aa951287d0300fe8905340b909d6858ae90dd8e8618b189eefd5" => :sierra
    sha256 "6e40fe830045c93763c5e9eeede0581629f5ae20b09870f0ea280f847da289aa" => :el_capitan
    sha256 "bb4a930f0d5dc90cfc028219f78078a461eba4c1b2092af266d7c4acecbcae24" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[docopt].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
