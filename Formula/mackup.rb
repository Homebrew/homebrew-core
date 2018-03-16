class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.17.tar.gz"
  sha256 "914ce2f5d29f8c0472da63ddb28497beec5317a1f17912f2a1fed284ccea3b84"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c32971d904c35725a6c6c819b3e5c4e7ad66035a9052ba2f030c5d3e819d60ab" => :high_sierra
    sha256 "c32971d904c35725a6c6c819b3e5c4e7ad66035a9052ba2f030c5d3e819d60ab" => :sierra
    sha256 "cb2d640806966eda5980497bbbe7bcf00a2ca89dd0f924cf99e48ffe42841237" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
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
