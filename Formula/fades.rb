class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/59/18/cc80eb5c0a2e15c4b95df6a3c6158e06acb2e075ef2b811753936a6bdf57/fades-6.0.1.tar.gz"
  sha256 "747ee3a159be1cb7512fd7ea4163d22e2734209e474aa2dbbccc29a0f0c92d09"
  head "https://github.com/PyAr/fades.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c24a39184e8fb1c487e6c579b3fd66aba3e6c13be4f86c5583ce59beaab99655" => :sierra
    sha256 "8a6869cbb401853eff4aa5c176feebdcb0b493ec09052f9f7a516d87320d96f3" => :el_capitan
    sha256 "8a6869cbb401853eff4aa5c176feebdcb0b493ec09052f9f7a516d87320d96f3" => :yosemite
  end

  depends_on :python3

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system "#{bin}/fades", testpath/"test.py"
  end
end
