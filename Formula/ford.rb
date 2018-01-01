class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/cmacmackin/ford/"
  url "https://github.com/cmacmackin/ford/archive/v5.0.6.tar.gz"
  sha256 "18d46dc4c6fec57ae0124b412d4db23a37d07a3849f41fa5bf4fb66deaed9615"
  head "https://github.com/cmacmackin/ford.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdf7c838602b5d38b6f12293a8d36100a5c2e879bae2f1d86e14077fd7fa1b19" => :high_sierra
    sha256 "c738a796ee8a8adfdcb8358eb93e3a87530523b6260151d82a5003a1ed8af532" => :sierra
    sha256 "47599cea228882fef8c4efaa0e52e8135ab58d6d3c7bed9efc29a0bd72d46716" => :el_capitan
    sha256 "af2a90e3a5af08077676bdcf241c4cf61525c90164b92c5dc137a78237cce3e3" => :yosemite
    sha256 "2c47a80b78dfec14df17313c888c2828ace07b848859be62b459ff2d60403fcb" => :mavericks
  end

  option "without-lxml", "Do not install lxml to improve the speed of search  database generation"

  depends_on "graphviz"
  depends_on "python" if MacOS.version <= :snow_leopard

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/86/ea/8e9fbce5c8405b9614f1fd304f7109d9169a3516a493ce4f7f77c39435b7/beautifulsoup4-4.5.1.tar.gz"
    sha256 "3c9474036afda9136aac6463def733f81017bf9ef3510d25634f335b0c87f5e1"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/3a/ef/4be504e14ef8c96503aeb774937b1539aa2c6982e1edffd655ac3b7f2041/graphviz-0.5.1.zip"
    sha256 "d8f8f369a5c109d3fc971bbc1860b6848515d210aee8f5019c460351dbb00a50"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/4f/3f/cf6daac551fc36cddafa1a71ed48ea5fd642e5feabd3a0d83b8c3dfd0cb4/lxml-3.6.4.tar.gz"
    sha256 "61d5d3e00b5821e6cda099b3b4ccfea4527bf7c595e0fb3a7a760490cedd6172"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/9b/53/4492f2888408a2462fd7f364028b6c708f3ecaa52a028587d7dd729f40b4/Markdown-2.6.6.tar.gz"
    sha256 "9a292bb40d6d29abac8024887bcfc1159d7a32dc1d6f1f6e8d6d8e293666c504"
  end

  resource "markdown-include" do
    url "https://files.pythonhosted.org/packages/ef/44/eb6e9b4fa1110b719abb876c9b6dd8b46af886a94536ec4e9117fe5e7b97/markdown-include-0.5.1.tar.gz"
    sha256 "72a45461b589489a088753893bc95c5fa5909936186485f4ed55caa57d10250f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "md-environ" do
    url "https://files.pythonhosted.org/packages/68/a9/86666edbf0d3929d5b3be3347c153881139aa1e28af38f6496edcc034003/md-environ-0.1.0.tar.gz"
    sha256 "fe3c2a255af523d6f522831c699336cd71f9d543714067d93206ed35836f1793"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/f6/f7/875e23067652488ae40603336fdd63510a1e1853672b5b829a78452fd31c/toposort-1.4.tar.gz"
    sha256 "c190b9d9a9e53ae2835f4d524130147af601fbd63677d19381c65067a80fa903"
  end

  def install
    venv = virtualenv_create(libexec)
    deps = build.with?("lxml") ? resources : resources - [resource("lxml")]
    venv.pip_install deps
    venv.pip_install_and_link buildpath
    doc.install "2008standard.pdf", "2003standard.pdf"
    pkgshare.install "example-project-file.md"
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
      you can provide inline math using like \( y = x^2 \) or math on its own line
      like \[ x = \sqrt{y} \] or $$ e = mc^2. $$ You can even use LaTeX environments!
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
    system "#{bin}/ford", testpath/"test-project.md"
    assert_predicate testpath/"doc"/"index.html", :exist?
  end
end
