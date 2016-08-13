class Ford < Formula
  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/cmacmackin/ford/"
  url "https://files.pythonhosted.org/packages/d2/0a/db879742b03ffd136b0c18704697d5df9af779e0d2321412f46a48f424e4/FORD-5.0.4.tar.gz"
  sha256 "a6ec4eac90a3baa2ed59435bf9e94f6f1a40f49881ac6e642d23471767a52db6"
  head "https://github.com/cmacmackin/ford.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02c6c73955daf738ef03e2afb8a11b8da366305d8a7b49e7640b65aff0dce0a9" => :el_capitan
    sha256 "acc66051b0c87da1791696365a7ddb3fda45e33d6f6de541013fcf87b92c7e91" => :yosemite
    sha256 "40bb0a5df542b7dc349218131aae179fc653eb2841938765bcbc59b0b4cfa56a" => :mavericks
  end

  option "without-lxml", "Do not install lxml to improve the speed of search  database generation"

  depends_on "graphviz"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/28/fa/69128a30854bcae479a9a09737e489b6e6e6b7d2cf5898ddf7b2f49bf143/beautifulsoup4-4.5.0.tar.gz"
    sha256 "8e084c88b7664692e43576f121adb902e749ce0354e2becfb0f5220dcc20c9e5"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/3d/6d/406cec4d782d3cd6cb02d90bb17fbd364cab4a2a96d8ad0b5ccb46fd7442/graphviz-0.4.10.zip"
    sha256 "61e9f7126f5efdd11fb9269d4622277fbf8ed92046b73f3e78529e3be6a95f15"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/09/f3/c41293bc181b8c727cc485339dc57af653dae6d17d4c8dbf0cbac53cb4aa/lxml-3.6.1.tar.gz"
    sha256 "3eefcfbc548f8df38063b26c9686554268c1eb736e52cd230ff148aa550239d1"
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
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    deps = (build.with? "lxml") ? resources : resources - [resource("lxml")]
    deps.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test-project.md").write <<-EOS.undent
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
      (testpath/"src"/"ford_test_program.f90").write <<-EOS.undent
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
    assert File.exist?(testpath/"doc"/"index.html")
  end
end
