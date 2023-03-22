class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/Fortran-FOSS-Programmers/ford"
  url "https://files.pythonhosted.org/packages/ea/d4/57cd696162d780a6ec717a3b109673d67069d6d43982ee3947e4ab6e2014/FORD-6.2.1.tar.gz"
  sha256 "5364471dbc01963d1928139177ec67b5d023b92aa56d34c019479ed87fc3dd57"
  license "GPL-3.0-or-later"
  head "https://github.com/Fortran-FOSS-Programmers/ford.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "718167f7b77ece582a60ac3a80f596b9f6c6c95988b8c0aae857d794aad08b71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d4f04bf895c48b43333d8ca797ba48f35418da773f28338ce124baf9ff7dae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7daa948a7cde3f051a44b90046aba70b76a6892b7c87505281a880c51fccdc6f"
    sha256 cellar: :any_skip_relocation, ventura:        "16f733f34b9a49577180df3bddcdaadd1cb945892745f3ad4d07979d33532a97"
    sha256 cellar: :any_skip_relocation, monterey:       "fe93a5f9b0f71017bafe40aa8f6f7b6fd3eb7f24be132990e0b4b262ed467fb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "af1ebd0f49841d06bf19cc303b01b8fafcf586b3b41490cf7f19047b44e6c340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814616371b2f9f6a9d2692cfea5cbb720f87ef6e3ef3a3f13cdbb22e9cb5df6c"
  end

  depends_on "graphviz"
  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c5/4c/b5b7d6e1d4406973fb7f4e5df81c6f07890fa82548ac3b945deed1df9d48/beautifulsoup4-4.12.0.tar.gz"
    sha256 "c5fceeaec29d09c84970e47c65f2f0efe57872f7cff494c9691a26ec0ff13234"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/a5/90/fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321/graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/66/bf/a7c9e8cc23c105633b74e3280c2b06d13273da0df389e59395188d440017/Markdown-3.4.2.tar.gz"
    sha256 "e104be388c28462b4e83bd0ddfc68eff6022305cc4b5ab14caf8d235fae132b9"
  end

  resource "markdown-include" do
    url "https://files.pythonhosted.org/packages/5d/9c/7f53ad33ec7b7243910f8a5c3335c895fb070dc21b2e38b5a38d6a966c0c/markdown-include-0.7.2.tar.gz"
    sha256 "84070d0244367f99bdf9bbdd49ff7b9f51517bbee7582ad7aa8ff363e30d8157"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "python-markdown-math" do
    url "https://files.pythonhosted.org/packages/ec/17/e7e3f3fce951b8adec10987834f4b2fa721ebd9bd6651ce2a4f39c4c544d/python-markdown-math-0.8.tar.gz"
    sha256 "8564212af679fc18d53f38681f16080fcd3d186073f23825c7ce86fadd3e3635"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/1b/cb/34933ebdd6bf6a77daaa0bd04318d61591452eb90ecca4def947e3cb2165/soupsieve-2.4.tar.gz"
    sha256 "e28dba9ca6c7c00173e34e4ba57448f0688bb681b7c5e8bf4971daafc093d69a"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/b2/be/67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48/toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  def install
    virtualenv_install_with_resources
    doc.install "2008standard.pdf", "2003standard.pdf"
    pkgshare.install "example/example-project-file.md"
  end

  test do
    (testpath/"test-project.md").write <<~EOS
      project_dir: ./src
      output_dir: ./doc
      project_github: https://github.com/cmacmackin/futility
      project_website: https://github.com
      summary: Some Fortran program which I wrote.
      author: John Doe
      author_description: I program stuff in Fortran.
      github: https://github.com/cmacmackin
      email: john.doe@example.com
      predocmark: >
      docmark_alt: #
      predocmark_alt: <
      macro: TEST
             LOGIC=.true.

      This is a project which I wrote. This file will provide the documents. I'm
      writing the body of the text here. It contains an overall description of the
      project. It might explain how to go about installing/compiling it. It might
      provide a change-log for the code. Maybe it will talk about the history and/or
      motivation for this software.

      @Note
      You can include any notes (or bugs, warnings, or todos) like so.

      You can have as many paragraphs as you like here and can use headlines, links,
      images, etc. Basically, you can use anything in Markdown and Markdown-Extra.
      Furthermore, you can insert LaTeX into your documentation. So, for example,
      you can provide inline math using like ( y = x^2 ) or math on its own line
      like [ x = \sqrt{y} ] or $$ e = mc^2. $$ You can even use LaTeX environments!
      So you can get numbered equations like this:
      \begin{equation}
        PV = nRT
      \end{equation}
      So let your imagination run wild. As you can tell, I'm more or less just
      filling in space now. This will be the last sentence.
    EOS
    mkdir testpath/"src" do
      (testpath/"src"/"ford_test_program.f90").write <<~EOS
        program ford_test_program
          !! Simple Fortran program to demonstrate the usage of FORD and to test its installation
          use iso_fortran_env, only: output_unit, real64
          implicit none
          real (real64) :: global_pi = acos(-1)
          !! a global variable, initialized to the value of pi

          write(output_unit,'(A)') 'Small test program'
          call do_stuff(20)

        contains
          subroutine do_stuff(repeat)
            !! This is documentation for our subroutine that does stuff and things.
            !! This text is captured by ford
            integer, intent(in) :: repeat
            !! The number of times to repeatedly do stuff and things
            integer :: i
            !! internal loop counter

            ! the main content goes here and this is comment is not processed by FORD
            do i=1,repeat
               global_pi = acos(-1)
            end do
          end subroutine
        end program
      EOS
    end
    system bin/"ford", testpath/"test-project.md"
    assert_predicate testpath/"doc"/"index.html", :exist?
  end
end
