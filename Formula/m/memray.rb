class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/36/18/5df5995a7b142e12ab194f4b2fd1473efd51f4f622dfe47f3c013c3c11f7/memray-1.19.1.tar.gz"
  sha256 "7fcf306eae2c00144920b01913f42fa7f235af7a80fa3226ab124672a5cb1d8f"
  license "Apache-2.0"

  no_autobump! because: "`update-python-resources` cannot update resource blocks"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2d072fad3df8ecf71559500dd07394143b8049f6f2ac0fa6e7a68c448409dd9"
    sha256 cellar: :any,                 arm64_sequoia: "435b44b2071742f5b6dd01b1f3c11e5e1c1f3766e02dcc6df71b42ecab24d385"
    sha256 cellar: :any,                 arm64_sonoma:  "df666e1456e9cb1eb5dc2ade2e7b502291bd24d1821eae2d2126bdb010061e9f"
    sha256 cellar: :any,                 sonoma:        "39e3599c7842e1d7e4a317f4276cc2de6ad778208825a2ead26b3719a035ee3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bac4073dc761cb244574af394a24ee6c7018cc0315ec223702808b4dfaf294a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d75359949ca5cb8466cd6bab8cbfc9af0236bea2bd2972c32ca8139892260729"
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
      url "https://sourceware.org/elfutils/ftp/0.193/elfutils-0.193.tar.bz2"
      sha256 "7857f44b624f4d8d421df851aaae7b1402cfe6bcdd2d8049f15fc07d3dde7635"
    end
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
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
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/ff/51/51a0863339c4c3fa204f43044e52dfd688a7ee2ba2c987e021acc9583a42/textual-6.3.0.tar.gz"
    sha256 "a89c557fa740611551dcf4f93643f33853eca488183ef5882200dde8e94315e8"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
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
