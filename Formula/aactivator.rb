class Aactivator < Formula
  include Language::Python::Virtualenv

  desc "Automatically source and unsource a project's environment"
  homepage "https://github.com/Yelp/aactivator"
  url "https://github.com/Yelp/aactivator/archive/v1.0.0.tar.gz"
  sha256 "395430f9dbabd2644a030d534761899165e2d5c8cb5aa71bf620808543cdfb02"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    To add aactivator to your shell, add the following line to your .bashrc or .zshrc:

       eval "$(aactivator init)"

    More information: https://github.com/Yelp/aactivator
    EOS
  end

  test do
    assert_match "aactivator", shell_output("#{bin}/aactivator -h")
  end
end
