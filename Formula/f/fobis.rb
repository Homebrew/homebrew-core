class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/53/3a/5533ab0277977027478b4c1285bb20b6beb221b222403b10398fb24e81a2/FoBiS.py-3.0.5.tar.gz"
  sha256 "ef23fde4199277abc693d539a81e0728571c349174da6b7476579f82482ab96c"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb6b8391538d007deff154f1ba61133fef780c47bb4ce5950f488678204a82ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef3655ae24dbc9c1db4ca7310e0085019c8363f6cd3fe6244825ddf704e88727"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48907a8772aaea92593c15fa496441b3e70fc6cd9ccbc6c33939ebb59da1afdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34bd55f9d976e63024d4db2f340be2807b0d10a52b1a6d33ae1af305a65123be"
    sha256 cellar: :any_skip_relocation, sonoma:         "086e21cc8fad72ee1c6e6797853a38a078bd39561cd824614a5ab6e71577d2e4"
    sha256 cellar: :any_skip_relocation, ventura:        "6979ae67c338a57331c033d7532e2f55919a15c5ba43263c5bf618b9e5ea8819"
    sha256 cellar: :any_skip_relocation, monterey:       "ad700a8e305dae8552c63fe769290b5aede0bb026df206d5f035429f5bccc651"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f30368491b20eb5a23162c69263500c829812a9fbd53fd3f2163d3d1818089e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b941e8f203bc59f207f77301a5bfd40262998d24b076fd3bfd56ccb5b0d3d64a"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.11"

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/4b/c0/3a47084aca7a940ed1334f89ed2e67bcb42168c4f40c486e267fe71e7aa0/configparser-5.3.0.tar.gz"
    sha256 "8be267824b541c09b08db124917f48ab525a6c3e837011f3130781a224c57090"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-mod.f90").write <<~EOS
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    EOS
    (testpath/"test-prog.f90").write <<~EOS
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    EOS
    system "#{bin}/FoBiS.py", "build", "-compiler", "gnu"
    assert_match "Hello FoBiS", shell_output(testpath/"test-prog")
  end
end
