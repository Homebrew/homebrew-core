class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.14.2.tar.xz"
  sha256 "8f8d38d70ed57164795fc55e19de4c11488fcd31dbe42094e44a92a23e3f5e92"
  head "https://github.com/nim-lang/Nim.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "db003cfcafe8a67f349ad6ab69dc527d1f702b0892325b777299b4a20b65a8f8" => :sierra
    sha256 "34f4f23ae2cfdff9000bbdab3ef3d8c591c3e84a0959b28d4e9ecabb3f97e821" => :el_capitan
    sha256 "8edeeedab5b808f140e5987062c51cc708b07e21aee39a81a9c70970c72ddaba" => :yosemite
    sha256 "a722af3627f9051373bd77d9969ec3e1422f9c86019369e81ea8b5a604fd6a29" => :mavericks
  end

  def install
    if build.head?
      system "/bin/sh", "bootstrap.sh"
    else
      system "/bin/sh", "build.sh"
    end
    system "/bin/sh", "install.sh", prefix

    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp
  end
end
