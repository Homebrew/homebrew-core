class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/f7/ec/3965a47a4bfb8426037061ab429320cc306c229827db1c213eda52fe4a4d/cppman-0.5.9.tar.gz"
  sha256 "15a4e40ab025b4dcec5a73a50df26b7ddaef7c148fcb197940fff2484f9e9903"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a95cc1c58b520b23b42327ee31062260c4b4ba4f9f84c6ed04f8ee8fffcdebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220b9a45ca0d042bd6ac5b367bcf39b4fd3a4336d6d61f6b3d98eee1310db2bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d06e98c5d58b5ed41584aec6f8be57eb1bcf56f447edc0a6bf795c74cfdffba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a96323828f982d28b348af2eb139a34dae85a248495fde981a082c687a97cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e61096985aefe69be35fdac8f537198efb7fcc85c9bceb5cc439266cae2e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e88d120761abc8d4909f0544824d057a3010c5a0232699f3a2af5d87e9e3bc6b"
  end

  depends_on "python@3.14"

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

    # Avoid ast.Str removed in 3.14+: https://github.com/html5lib/html5lib-python/pull/583
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/379f9476c2a5ee370cd7ec856ee9092cace88499.patch?full_index=1"
      sha256 "97ae2474704eedf72dc5d5c46ad86e2144c10022ea950cb1c42a9ad894705014"
    end
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/80/61/d3dc048cd6c7be6fe45b80cedcbdd4326ba4d550375f266d9f4246d0f4bc/lxml-5.3.2.tar.gz"
    sha256 "773947d0ed809ddad824b7b14467e1a481b8976e87278ac4a730c2f7c7fcddc1"
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
    url "https://files.pythonhosted.org/packages/76/ad/cd3e3465232ec2416ae9b983f27b9e94dc8171d56ac99b345319a9475967/typing_extensions-4.13.1.tar.gz"
    sha256 "98795af00fb9640edec5b8e31fc647597b4691f099ad75f469a2616be1a76dff"
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
    assert_match "std::extent", shell_output("#{bin}/cppman -f :extent")
  end
end
