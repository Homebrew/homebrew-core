class Envv < Formula
  desc "Shell-independent handling of environment variables"
  homepage "https://github.com/jakewendt/envv#readme"
  url "https://github.com/jakewendt/envv/archive/v1.7.tar.gz"
  sha256 "1db05b46904e0cc4d777edf3ea14665f6157ade0567359e28663b5b00f6fa59a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d47b445c7d02827f54b9cfd3341e2646d10f0156a9dcf27d7745988b1e4497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "023e55714270ba7a388b290d867a4fd334a962b33f4bd9d0ed8de513ad7c034b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21e6f6e3c94dd0f14178ba1d5a53317bf1a6bf269762b5b79d9f93eff1ae3f00"
    sha256 cellar: :any_skip_relocation, ventura:        "ab99488e9001da3147d116a80bc6f7235b60f6ca348587e573b92d20f88149aa"
    sha256 cellar: :any_skip_relocation, monterey:       "f58b94b534868176986117c6f3f2eb470388cc439c98308de6b2e99db8990c0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "39f8b46cce79836ebbc2281f1836a30eb2440e5af70bdc251469c0cca36f7828"
    sha256 cellar: :any_skip_relocation, catalina:       "54b7b425a3db83134fc9038b8672bd84a943413f5386d9cef92711eeaaade467"
    sha256 cellar: :any_skip_relocation, mojave:         "59acc1f13ed58898376a14ffcb23766f62ff7c0446eebb3ee8aa1f8162f0994c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "35e2781067a3f5429c36546a20faca9d4762882bf3908122efc58c8b752968e9"
    sha256 cellar: :any_skip_relocation, sierra:         "cc30a2317f78124c609d6313a33cea58c9d428a95903966da4cb42051630ef97"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3b2fb0b35749280461b3982797ceea34bfa42d63cb5c6547986cf106669ee744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb0c8481042567e17ff04b7d5dd3cc46fccbc0e321203770791588fc51d11b7"
  end

  def install
    system "make"

    bin.install "envv"
    man1.install "envv.1"
  end

  test do
    ENV["mylist"] = "A:B:C"
    assert_equal "mylist=A:C; export mylist", shell_output("#{bin}/envv del mylist B").strip
    assert_equal "mylist=B:C; export mylist", shell_output("#{bin}/envv del mylist A").strip
    assert_equal "mylist=A:B; export mylist", shell_output("#{bin}/envv del mylist C").strip

    assert_equal "", shell_output("#{bin}/envv add mylist B").strip
    assert_equal "mylist=B:A:C; export mylist", shell_output("#{bin}/envv add mylist B 1").strip
    assert_equal "mylist=A:C:B; export mylist", shell_output("#{bin}/envv add mylist B 99").strip

    assert_equal "mylist=A:B:C:D; export mylist", shell_output("#{bin}/envv add mylist D").strip
    assert_equal "mylist=D:A:B:C; export mylist", shell_output("#{bin}/envv add mylist D 1").strip
    assert_equal "mylist=A:B:D:C; export mylist", shell_output("#{bin}/envv add mylist D 3").strip
  end
end
