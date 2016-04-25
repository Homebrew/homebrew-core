class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.24.tar.gz"
  sha256 "b8458cde6ded905d4ae7a24187936f52713286bfdc3942033149dd2f2a871869"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ae7262046f5b657043b2eaf158d7e41171c7328eeb0c9f88c8dbea670bd50a3" => :el_capitan
    sha256 "da3f145ba253b64a440920f3c1121191d2ddfac4aa5f95c745daae5007f3d11e" => :yosemite
    sha256 "e0e6288ba060680e0f56a917328af07103e628030e9d11733329f5583b38ffd5" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec) }
    end

    system "python", *Language::Python.setup_install_args(prefix)

    bash_completion.install "cheat/autocompletion/cheat.bash"
    zsh_completion.install "cheat/autocompletion/cheat.zsh" => "_cheat"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/cheat", "tar"
  end
end
