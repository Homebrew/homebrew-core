class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/a2/97/b0c1de5b35cc4e66eb32accffd261c22d511aba964a7aed3b210a85851b7/cppman-0.6.3.tar.gz"
  sha256 "16a782b87b0848c5202b61965402258f8fc8260cbf0867cb876992eb3d046eb0"
  license "GPL-3.0-or-later"
  head "https://github.com/aitjcize/cppman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0753f3c0011f608d95c1f9b45f6ecaf0061da6aae053d40bd43db921049ba5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "067845e68c81d2428eec951a67388cc308b3aff83557a93161638c67ff34757c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcfe857c334c4352da0039bc7cca8bef7fd82da434850f365441f08380554ab2"
    sha256 cellar: :any,                 arm64_linux:       "d618a791f0d969687aadcee96ae29bb9bf2d9fab955cef7a7373b48667002abe"
    sha256 cellar: :any,                 x86_64_linux:      "66870113f84fb52f6d19e84af03f695eaeb3d8cef3ffbd7051ec83fdb7056543"
  end

  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/f0/3c/adaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439/beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Avoid ast.Str removed in 3.14+
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/379f9476c2a5ee370cd7ec856ee9092cace88499.patch?full_index=1"
      sha256 "97ae2474704eedf72dc5d5c46ad86e2144c10022ea950cb1c42a9ad894705014"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/583"
    end

    # Python 3.14 with setuptools 81+ compatibility (`pkg_resources` removal)
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/1dbc19cd6db72cb919885827bc4883423e0cb647.patch?full_index=1"
      sha256 "5951b823f353dd70806ad6e163ab8f46899496c1e8bb53970c99abe8d1df1a78"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/592"
    end
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
    # NOTE: Excluding bash completion which uses GNU xargs so has issues on macOS
    fish_completion.install_symlink libexec/"share/fish/vendor_completions.d/cppman.fish"
    zsh_completion.install_symlink libexec/"share/zsh/vendor-completions/_cppman"
  end

  test do
    system bin/"cppman", "-s", "cplusplus.com"
    assert_match "std::extent", shell_output("#{bin}/cppman -n 1 -f :extent")
  end
end
