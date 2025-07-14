class Memray < Formula
  include Language::Python::Virtualenv

  desc "Memory profiler for Python applications"
  homepage "https://bloomberg.github.io/memray/"
  url "https://files.pythonhosted.org/packages/df/40/66e6ae86c0a22b8b998779fa8d6c0ab9ee63f0943198adcf714934286cbf/memray-1.17.2.tar.gz"
  sha256 "eb75c075874a6eccddf361513d9d4a9223dd940580c6370a6ba5339bae5d0ba2"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c4efb8fb7ecbf0afe0d4caabec09224e2b2536bd9ed879d158c889328707a6a"
    sha256 cellar: :any,                 arm64_sonoma:  "6339196a5e610a541f4e9514ba7f39f4964e32e034a7a3c813f476a5526badc9"
    sha256 cellar: :any,                 arm64_ventura: "0441f370654154a80c6ff3d829b604608f65e7f470e4e57995231bb4ec1c7071"
    sha256 cellar: :any,                 sonoma:        "bf7bad5d0a61b6bb39e233627bde0270b2491667a44f65fb788afb39824df938"
    sha256 cellar: :any,                 ventura:       "f9385c4a945339ff46b94106acb15adb96d44ff77f57908219663000618121f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "025020899fa12f0a4dd1889e0680836d51e3c83dbd720ac6e480f38e246cfe23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a28919d12faf4b7c84f982a791ec7b034d4606c03563973220eb0cf6315af6"
  end

  depends_on "lz4"
  depends_on "python@3.13"

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
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/19/03/a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fd/mdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a1/53/830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8/rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/34/99/8408761a1a1076b2bb69d4859ec110d74be7515552407ac1cb6b68630eb6/textual-3.2.0.tar.gz"
    sha256 "d2f3b0c39e02535bb5f2aec1c45e10bd3ee7508ed1e240b7505c3cf02a6f00ed"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
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
