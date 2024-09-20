class Gitgen < Formula
    include Language::Python::Virtualenv
  
    desc "A CLI tool for generating git commits to boost your GitHub activity"
    homepage "https://pypi.org/project/gitgen/"
    url "https://github.com/mubashardev/gitgen/archive/refs/tags/v0.1.1.tar.gz" # Replace with your latest version
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    license "MIT"
    revision 1
    depends_on "python@3.9"
  
    def install
      virtualenv_install_with_resources
    end
  
    test do
      system "#{bin}/gitgen", "--version"
    end
  end