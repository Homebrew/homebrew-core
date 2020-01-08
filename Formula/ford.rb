class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/cmacmackin/ford/"
  url "https://github.com/cmacmackin/ford/archive/v6.0.0.tar.gz"
  sha256 "45fd53c7e5263fea2e751c436de6a1513d250647e98e32668b9965677974309e"
  revision 1
  head "https://github.com/cmacmackin/ford.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b41b1ea27a1dc046419dffbee8e6f851be7f4c7fd0d6eda620d70e21d2e05b62" => :catalina
    sha256 "3ddd7cf499d849e98639de2ffa9685e9ba99680ccec7a9b2d036c29f1d774052" => :mojave
    sha256 "12211376646fed6327a0f00f7db6c3b6905c8edcd9e0049ed19fb304a5c6b94c" => :high_sierra
    sha256 "58806e9e273eabbb7de882785be5af3ba464bafac263b9586822853481ad99d2" => :sierra
  end

  depends_on "graphviz"
  depends_on "python"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/fa/8d/1d14391fdaed5abada4e0f63543fef49b8331a34ca60c88bd521bcf7f782/beautifulsoup4-4.6.0.tar.gz"
    sha256 "808b6ac932dccb0a4126558f7dfdcf41710dd44a4ef497a0bb59a77f9f078e89"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/21/e8/13b0523da93d7189d9ab30097cdd2ffe78f88b0cc69f341749dec562b731/graphviz-0.8.4.zip"
    sha256 "4958a19cbd8461757a08db308a4a15c3d586660417e1e364f0107d2fe481689f"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/54/a6/43be8cf1cc23e3fa208cab04ba2f9c3b7af0233aab32af6b5089122b44cd/lxml-4.2.3.tar.gz"
    sha256 "622f7e40faef13d232fb52003661f2764ce6cdef3edb0a59af7c1559e4cc36d1"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"
    sha256 "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"
  end

  resource "markdown-include" do
    url "https://files.pythonhosted.org/packages/ef/44/eb6e9b4fa1110b719abb876c9b6dd8b46af886a94536ec4e9117fe5e7b97/markdown-include-0.5.1.tar.gz"
    sha256 "72a45461b589489a088753893bc95c5fa5909936186485f4ed55caa57d10250f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "md-environ" do
    url "https://files.pythonhosted.org/packages/68/a9/86666edbf0d3929d5b3be3347c153881139aa1e28af38f6496edcc034003/md-environ-0.1.0.tar.gz"
    sha256 "fe3c2a255af523d6f522831c699336cd71f9d543714067d93206ed35836f1793"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/e5/d8/9bc1598ddf74410beba243ffeaee8d0b3ca7e9ac5cefe77367da497433e1/toposort-1.5.tar.gz"
    sha256 "dba5ae845296e3bf37b042c640870ffebcdeb8cd4df45adaa01d8c5476c557dd"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/41/61/d36ff28878ca73bb3932dfa6bab36ff872e6dac18c9ace328879b1798279/tqdm-4.23.4.tar.gz"
    sha256 "77b8424d41b31e68f437c6dd9cd567aebc9a860507cb42fbd880a5f822d966fe"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
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
