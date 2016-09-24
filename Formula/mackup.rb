class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.14.tar.gz"
  sha256 "d8b7c2f2d1650b132ca31035e625ee436a7b4ff9a9948119cf3f370fc3b17d22"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71b67496c5c1560435638687edf7e9c7e21a249ad5be8a4964bb9ed508a03866" => :sierra
    sha256 "1885800a4fd4072ef36f17c01f8b589ef88901b36d50eea784bbb5983b6a2c2d" => :el_capitan
    sha256 "91556d1517c601587bd50739831ea0bcb25d658ca255e338804672a33ea056b4" => :yosemite
    sha256 "9643c1c1f03318e3cf8b9e52054d658dcc82182dedeae1388be58e5ff56006d9" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
