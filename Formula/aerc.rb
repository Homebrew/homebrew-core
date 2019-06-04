class Aerc < Formula
  include Language::Python::Virtualenv

  desc "The world's best email client"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~sircmpwn/aerc/archive/0.1.0.tar.gz"
  sha256 "d33e2e4401c29f3d021e5d0a8aac2a85efa15d72618809278131147d12a0a973"

  depends_on "go" => :build
  depends_on "scdoc" => :build

  depends_on "dante"
  depends_on "python"
  depends_on "w3m"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    inreplace "contrib/plaintext.py", "/usr/bin/env python3", "#{libexec}/bin/python3"
    inreplace "contrib/hldiff.py", "/usr/bin/env python3", "#{libexec}/bin/python3"

    system "make", "LDFLAGS=", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
  test do
    # TODO: aerc doesn't support any flags. Add simple test when `aerc --version` is available
    system "true"
  end
end
