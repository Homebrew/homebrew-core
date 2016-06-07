class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.14.0.tar.xz"
  sha256 "023524b422c745a8fc2ee1207e35babbeb9c6b5f81a3bf85071986b48debd6a5"
  head "https://github.com/nim-lang/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    sha256 "9de8a96411f3972403d8592339539d781b0eff68839d2d5d66cfdf21abc5e198" => :el_capitan
    sha256 "ea92442a591de42a008e27c98842186f4bb083b0e16072217cc5627acb8111c8" => :yosemite
    sha256 "b824926db0dac9c09162deb31770544a4a22c397156eb8f9052f0911b68820ba" => :mavericks
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
