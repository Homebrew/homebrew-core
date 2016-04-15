class Ford < Formula
  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/cmacmackin/ford/"
  url "https://pypi.python.org/packages/source/F/FORD/FORD-4.5.4.tar.gz"
  sha256 "fc32eb17c2aa6bfd89e4168f237b7f66a9892c00dcc94a7ce6af08d05cdfdfc1"

  head "https://github.com/cmacmackin/ford.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb26478ea06f54144761c661dcf58c787eae7817468d0721cb26959ea31d03d6" => :el_capitan
    sha256 "13e813ef93febe740eeb91f0ec0a8816673af19802f09223577f89352e5cf5ee" => :yosemite
    sha256 "0b513d22c17e06f4d7021d9f69a0254a33c24e5197b02224280e275af0599971" => :mavericks
  end

  depends_on "graphviz"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.4.1.tar.gz"
    sha256 "87d4013d0625d4789a4f56b8d79a04d5ce6db1152bb65f1d39744f7709a366b4"
  end

  resource "graphviz" do
    url "https://pypi.python.org/packages/source/g/graphviz/graphviz-0.4.10.zip"
    sha256 "61e9f7126f5efdd11fb9269d4622277fbf8ed92046b73f3e78529e3be6a95f15"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.6.6.tar.gz"
    sha256 "9a292bb40d6d29abac8024887bcfc1159d7a32dc1d6f1f6e8d6d8e293666c504"
  end

  resource "markdown-include" do
    url "https://pypi.python.org/packages/source/m/markdown-include/markdown-include-0.5.1.tar.gz"
    sha256 "72a45461b589489a088753893bc95c5fa5909936186485f4ed55caa57d10250f"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "toposort" do
    url "https://pypi.python.org/packages/source/t/toposort/toposort-1.4.tar.gz"
    sha256 "c190b9d9a9e53ae2835f4d524130147af601fbd63677d19381c65067a80fa903"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[beautifulsoup4 graphviz Jinja2 Markdown markdown-include MarkupSafe Pygments toposort].each do |r|
      resource(r).stage do
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
