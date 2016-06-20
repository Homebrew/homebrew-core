class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/chrisallenlane/cheat"
  url "https://github.com/chrisallenlane/cheat/archive/2.1.25.tar.gz"
  sha256 "3627da400caebe5a813aec4f76f4d0999d4ed80d4eff0023f6e1a2a2de016e2f"
  head "https://github.com/chrisallenlane/cheat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3e7039546197e8747966f52338033d203db340fc3816d2c81588cb87316f622" => :el_capitan
    sha256 "9dfbfa311c6a57b9071170229c0af543422e68cb6a974e4d630d52b166a4e4eb" => :yosemite
    sha256 "bf4fbbbff20150fb796dffd28b8038be00fcfe76161dee5b067f64a2fbbf1065" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bash_completion.install "cheat/autocompletion/cheat.bash"
    zsh_completion.install "cheat/autocompletion/cheat.zsh" => "_cheat"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"cheat", "tar"
  end
end
