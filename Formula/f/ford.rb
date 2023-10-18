class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/Fortran-FOSS-Programmers/ford"
  url "https://files.pythonhosted.org/packages/4a/7a/6f9d884cc034122170efb8b34b814619ba5e59568e6366564f01b85ebf81/FORD-7.0.0.tar.gz"
  sha256 "4822a4f9c707cfedb955fb18a09a0ef380c8c1ac2a103f8cb4494219dfa546a5"
  license "GPL-3.0-or-later"
  head "https://github.com/Fortran-FOSS-Programmers/ford.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1823a19d47e1764f7f514a6a066b82fbf993ac6dff153b13f9b89b13559babd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c222e067e96f8a40f7bf0d374f2264eb6d575764479bf38e896451e40eae0bf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ca73edbd777f863181c4640929c0bf5f2ca3d822dca9ba92208f3963c778c10"
    sha256 cellar: :any_skip_relocation, sonoma:         "f19900fb8523f4041ffbb47d7d0357a4f7acf0d19ecc85ca0ae5ef0326edd0b6"
    sha256 cellar: :any_skip_relocation, ventura:        "42f719ee35c2d74ba3b4f85cac1144689de50ba42c4083c557564f53431c1f41"
    sha256 cellar: :any_skip_relocation, monterey:       "3b3f340c540305e8910a799d2e73b3198c316dda1a39c499bb006f4765ef0851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "322bfe669755be8144f14bde607ab1e2d09f57a4dfd20b9ec5f24fd416b487cb"
  end

  depends_on "graphviz"
  depends_on "pygments"
  depends_on "python-markdown"
  depends_on "python-markupsafe"
  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/a5/90/fb047ce95c1eadde6ae78b3fca6a598b4c307277d4f8175d12b18b8f7321/graphviz-0.20.1.zip"
    sha256 "8c58f14adaa3b947daf26c19bc1e98c4e0702cdc31cf99153e6f06904d492bf8"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markdown-include" do
    url "https://files.pythonhosted.org/packages/5d/9c/7f53ad33ec7b7243910f8a5c3335c895fb070dc21b2e38b5a38d6a966c0c/markdown-include-0.7.2.tar.gz"
    sha256 "84070d0244367f99bdf9bbdd49ff7b9f51517bbee7582ad7aa8ff363e30d8157"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pcpp" do
    url "https://files.pythonhosted.org/packages/41/07/876153f611f2c610bdb8f706a5ab560d888c938ea9ea65ed18c374a9014a/pcpp-1.30.tar.gz"
    sha256 "5af9fbce55f136d7931ae915fae03c34030a3b36c496e72d9636cedc8e2543a1"
  end

  resource "python-markdown-math" do
    url "https://files.pythonhosted.org/packages/ec/17/e7e3f3fce951b8adec10987834f4b2fa721ebd9bd6651ce2a4f39c4c544d/python-markdown-math-0.8.tar.gz"
    sha256 "8564212af679fc18d53f38681f16080fcd3d186073f23825c7ce86fadd3e3635"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
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
      project: Example Project
      summary: This is a short example project
          that demonstrates many of Ford's features
      src_dir: ./src
      output_dir: ./doc
      project_github: https://github.com/cmacmackin/futility
      project_website: https://github.com
      summary: Some Fortran program which I wrote.
      author: John Doe
      author_description: I program stuff in Fortran.
      github: https://github.com/cmacmackin
      email: john.doe@example.com
      fpp_extensions: fpp
      preprocess: false
      macro: HAS_DECREMENT
      predocmark: >
      docmark_alt: #
      predocmark_alt: <
      display: public
              protected
      source: false
      graph: true
      search: true
      extra_mods: json_module: http://jacobwilliams.github.io/json-fortran/
                  futility: http://cmacmackin.github.io
      license: by-nc
      extra_filetypes: sh #
      max_frontpage_items: 4
      exclude: src/excluded_file.f90
      exclude_dir: src/excluded_directory
      page_dir: pages
      ---

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
