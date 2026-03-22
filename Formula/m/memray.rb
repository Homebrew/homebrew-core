class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/e9/db/56ff21f47be261ab781105b233d1851d3f2fcdd4f08ebf689f6d6fd84f0d/memray-1.19.2.tar.gz"
  sha256 "680cb90ac4564d140673ac9d8b7a7e07a8405bd1fb8f933da22616f93124ca84"
  license "Apache-2.0"

  no_autobump! because: "`update-python-resources` cannot update resource blocks"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2b8be477afa8dd1e3725a17c9b996e7b9c0ae89ad85af9a63cc7174842d187a"
    sha256 cellar: :any,                 arm64_sequoia: "70b5d903a69cc55f60a65b6f585356e14c80704d68b4ff07303771373511d088"
    sha256 cellar: :any,                 arm64_sonoma:  "9f4f637bd8a853a70c6b9c1c9925335d083e11774a573d31fb1bf8d4fdd79ce4"
    sha256 cellar: :any,                 sonoma:        "5c242be80135748ad4b4938cd7d38754327f76cbf2a7e87555033995cdae94ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f68832bdcfc91e10951673c6ec7f68ba07dc081e43a3d72ac483540701e48dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f95d1edfeface09b7133e4bc6d0f16a44dda8c3b55351c9f9fc91331772717a"
  end

  depends_on "lz4"
  depends_on "python@3.14"

  on_linux do
    depends_on "pkgconf" => :build # for libdebuginfod
    depends_on "curl" # for libdebuginfod
    depends_on "elfutils" # for libdebuginfod
    depends_on "json-c" # for libdebuginfod
    depends_on "libunwind"

    # TODO: Consider creating a formula for (lib)debuginfod
    resource "elfutils" do
      url "https://sourceware.org/elfutils/ftp/0.194/elfutils-0.194.tar.bz2"
      sha256 "09e2ff033d39baa8b388a2d7fbc5390bfde99ae3b7c67c7daaf7433fbcf0f01e"
    end
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/72/23/8c709655c5f2208ee82ab81b8104802421865535c278a7649b842b129db1/textual-8.1.1.tar.gz"
    sha256 "eef0256a6131f06a20ad7576412138c1f30f92ddeedd055953c08d97044bc317"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  def install
    if OS.linux?
      without = "elfutils"
      libelf = Formula["elfutils"].opt_lib/"libelf.so"
      resource("elfutils").stage do
        # https://github.com/bloomberg/memray/blob/main/pyproject.toml#L96-L104
        system "./configure", "--disable-debuginfod",
                              "--disable-nls",
                              "--disable-silent-rules",
                              "--enable-libdebuginfod",
                              *std_configure_args(prefix: libexec)
        system "make", "-C", "debuginfod", "install", "bin_PROGRAMS=", "libelf=#{libelf}"
        ENV.append "LDFLAGS", "-L#{libexec}/lib -Wl,-rpath,#{libexec}/lib"
      end
    end
    virtualenv_install_with_resources(without:)
  end

  test do
    system bin/"memray", "run", "--output", "output.bin", "-c", "print()"
    assert_path_exists testpath/"output.bin"

    assert_match version.to_s, shell_output("#{bin}/memray --version")
  end
end
