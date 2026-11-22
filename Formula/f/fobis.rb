class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/c4/eb/e41852d6af7d98c690c06313d89b56d220528b9ac17f7d3bc8a2f45e2bc6/fobis_py-3.19.2.tar.gz"
  sha256 "92b4cfae1ac413a907722d85069f6a30a9253d4311cf6cd320194d2a12e7a00f"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "a1e602c8b97f3ea2d16c3075eb2dea7a927a8b30ebabaf0f15a1769dc78d3d44"
    sha256 cellar: :any_skip_relocation, all: "80812c317e32847df246dc767e6e13f0a06f2703233c21de3ec2e2da77315cc6"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "pydantic"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/0b/7d/bdbf3062e5dae31da8b3de1e3269110beb93d268df4a7f6d22b167c6cee0/annotated_doc-0.0.7.tar.gz"
    sha256 "0a30ef8f5322a4173720ae6712dc9a5e58f5a19868f3f167b4b5778db066c2b5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/bf/21/37383ece7d0a4995fb8ea97729207c4292b3ff94085002f37b2387063cfb/typer-0.29.2.tar.gz"
    sha256 "b1998dc5f2c3dedafa1517a9521fa944cc4dc1fadcea085d81a3b10ebcaeb075"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"fobis", shell_parameter_format: :typer)
  end

  test do
    (testpath/"test-mod.f90").write <<~FORTRAN
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    FORTRAN

    (testpath/"test-prog.f90").write <<~FORTRAN
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    FORTRAN

    system bin/"FoBiS.py", "build", "-compiler", "gnu"
    assert_match "Hello FoBiS", shell_output(testpath/"test-prog")
  end
end
