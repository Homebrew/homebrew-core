class Ford < Formula
  include Language::Python::Virtualenv

  desc "Automatic documentation generator for modern Fortran programs"
  homepage "https://github.com/Fortran-FOSS-Programmers/ford"
  url "https://files.pythonhosted.org/packages/9c/59/4bbf96923f76e1330b6b539396ab858d13a8602c724623f1202bb07075fa/ford-7.0.12.tar.gz"
  sha256 "96a3bec14f23c62db8a9c8072ebe1b6d6e043a315361923146e9cd459f913c59"
  license "GPL-3.0-or-later"
  head "https://github.com/Fortran-FOSS-Programmers/ford.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "621235af37f2a122f3e900ea892415874159261eafbd0562bafad45f7c0b7821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3dd7ba8cc5f58290eeeaf39516a3a7a70f84f8475a0f1799fd21c2eaa6e1831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50fcc0b97ea04424a129a861e9c95e6cf3acdb8877fd7c9622f58057281f48b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d9728b39d89cfe9367957050bf345efc8b67154569a978008090e37bd88218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b40fc5cb7fc265b675f5b9bb1bf62291b2ab10cebe1cb238587981de1ba3bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49260e1339f0a5d8688f06a55170e38ce457f8d91b789ba76c599f5a01a46d86"
  end

  depends_on "graphviz"
  depends_on "python@3.14"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/83/5a40d19b8347f017e417710907f824915fba411a9befd092e52746b63e9f/graphviz-0.20.3.zip"
    sha256 "09d6bc81e6a9fa392e7ba52135a9d49f1ed62526f96499325930e87ca1b5925d"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/87/2a/62841f4fb1fef5fa015ded48d02401cd95643ca03b6760b29437b62a04a4/Markdown-3.4.4.tar.gz"
    sha256 "225c6123522495d4119a90b3a3ba31a1e87a70369e03f14799ea9c0d7183a3d6"
  end

  resource "markdown-include" do
    url "https://files.pythonhosted.org/packages/5d/9c/7f53ad33ec7b7243910f8a5c3335c895fb070dc21b2e38b5a38d6a966c0c/markdown-include-0.7.2.tar.gz"
    sha256 "84070d0244367f99bdf9bbdd49ff7b9f51517bbee7582ad7aa8ff363e30d8157"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pcpp" do
    url "https://files.pythonhosted.org/packages/41/07/876153f611f2c610bdb8f706a5ab560d888c938ea9ea65ed18c374a9014a/pcpp-1.30.tar.gz"
    sha256 "5af9fbce55f136d7931ae915fae03c34030a3b36c496e72d9636cedc8e2543a1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "python-markdown-math" do
    url "https://files.pythonhosted.org/packages/4c/68/fbea05ec6fb318bdcf56ea47596605614554f51d77bfd14f6fb481139ad8/python_markdown_math-0.9.tar.gz"
    sha256 "567395553dc4941e79b3789a1096dcabb3fda9539d150d558ef3507948b264a3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "toposort" do
    url "https://files.pythonhosted.org/packages/b2/be/67bec9a73041616dd359f06e997d56c9c99d252460a3f035411d97c96c48/toposort-1.7.tar.gz"
    sha256 "ddc2182c42912a440511bd7ff5d3e6a1cabc3accbc674a3258c8c41cbfbb2125"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
    doc.install "2008standard.pdf", "2003standard.pdf"
    pkgshare.install "example/example-project-file.md"
  end

  test do
    (testpath/"test-project.md").write <<~MARKDOWN
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
      extra_mods: json_module: https://jacobwilliams.github.io/json-fortran/
                  futility: https://cmacmackin.github.io
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
    MARKDOWN
    mkdir testpath/"src" do
      (testpath/"src/ford_test_program.f90").write <<~FORTRAN
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
      FORTRAN
    end
    system bin/"ford", testpath/"test-project.md"
    assert_path_exists testpath/"doc/index.html"
  end
end
