class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://github.com/aradi/fypp/archive/refs/tags/3.2.tar.gz"
  sha256 "33f48c8d2337db539865265ce33c7c50e4d521aacbd31ac7b7e8b189d771ce1d"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71600edbf0d5f3bb409914829eca26547427fab2f4fdbc655b3f1f9df1d4ca38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a534986e0607485a5088e84a4548d85a8ff2bef433b297a9a4dd74723283d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc79fb33610cac17e3b528644daf3e7b2757192bc521fc379c023f8fdb286ea8"
    sha256 cellar: :any_skip_relocation, sonoma:         "69203b19f11ba6376a810689af69e5c3018e57d5c8196f4e7f92738e63af5cf9"
    sha256 cellar: :any_skip_relocation, ventura:        "f3624958a898b186df3f4289def9d2bf3468b3448b4e3b3164b2e5790894d9a1"
    sha256 cellar: :any_skip_relocation, monterey:       "fc8e5543153995294780164406079f8d0356b3e2a713bab2fab9feec22e7e2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a25c3909fde50da5dbcecaf82f30e57cc28ff5b4cb975726cb30674332393fd"
  end

  depends_on "gcc" => :test
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"fypp", "--version"
    (testpath/"hello.F90").write <<~EOS
      program hello
      #:for val in [_SYSTEM_, _MACHINE_, _FILE_, _LINE_]
        print *, '${val}$'
      #:endfor
      end
    EOS
    system bin/"fypp", testpath/"hello.F90", testpath/"hello.f90"
    ENV.fortran
    system ENV.fc, testpath/"hello.f90", "-o", testpath/"hello"
    system testpath/"hello"
  end
end
