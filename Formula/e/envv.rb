class Envv < Formula
  desc "Shell-independent handling of environment variables"
  homepage "https://github.com/jakewendt/envv"
  url "https://github.com/jakewendt/envv/archive/refs/tags/v1.7.tar.gz"
  sha256 "1db05b46904e0cc4d777edf3ea14665f6157ade0567359e28663b5b00f6fa59a"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bdca25cfb60091dd430d3c09400d5d1498f03cb5a761c60750371643a2bb5ef2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2110b9d05836da02e31062ad025810c86e863d23c8a585dcb227da34c20e3376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58710a70856d6c30fbb8615800486e82d73abd17eb31e557ecd4b9aa41bfda7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2d47b445c7d02827f54b9cfd3341e2646d10f0156a9dcf27d7745988b1e4497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "023e55714270ba7a388b290d867a4fd334a962b33f4bd9d0ed8de513ad7c034b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21e6f6e3c94dd0f14178ba1d5a53317bf1a6bf269762b5b79d9f93eff1ae3f00"
    sha256 cellar: :any_skip_relocation, sonoma:         "35236b4deea1db94e696c3c4457ea500a027b315df28092d6a4269c9cfdb8065"
    sha256 cellar: :any_skip_relocation, ventura:        "ab99488e9001da3147d116a80bc6f7235b60f6ca348587e573b92d20f88149aa"
    sha256 cellar: :any_skip_relocation, monterey:       "f58b94b534868176986117c6f3f2eb470388cc439c98308de6b2e99db8990c0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "39f8b46cce79836ebbc2281f1836a30eb2440e5af70bdc251469c0cca36f7828"
    sha256 cellar: :any_skip_relocation, catalina:       "54b7b425a3db83134fc9038b8672bd84a943413f5386d9cef92711eeaaade467"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1a4f95cc571b62d3b42a9e96261ad3c1a79a0c22c9b2f09e1773f59748ca3e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb0c8481042567e17ff04b7d5dd3cc46fccbc0e321203770791588fc51d11b7"
  end

  # Fix missing header includes, see https://github.com/jakewendt/envv/pull/4
  patch do
    url "https://github.com/jakewendt/envv/commit/0445a7e4ada9067b3817d1b03edfb91ba59a8962.patch?full_index=1"
    sha256 "7c778b4ab19f53feefaef65003249e9dbd09ac80fb4a7c0828bb357422eb8683"
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

    assert_empty shell_output("#{bin}/envv add mylist B").strip
    assert_equal "mylist=B:A:C; export mylist", shell_output("#{bin}/envv add mylist B 1").strip
    assert_equal "mylist=A:C:B; export mylist", shell_output("#{bin}/envv add mylist B 99").strip

    assert_equal "mylist=A:B:C:D; export mylist", shell_output("#{bin}/envv add mylist D").strip
    assert_equal "mylist=D:A:B:C; export mylist", shell_output("#{bin}/envv add mylist D 1").strip
    assert_equal "mylist=A:B:D:C; export mylist", shell_output("#{bin}/envv add mylist D 3").strip
  end
end
