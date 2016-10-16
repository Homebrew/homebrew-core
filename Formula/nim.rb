class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  url "http://nim-lang.org/download/nim-0.15.0.tar.xz"
  sha256 "c514535050b2b2156147bbe6e23aafe07cd996b2afa2c81fa9a09e1cd8c669fb"
  head "https://github.com/nim-lang/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ee9b3cfbdde386c061e22ad3b2902b3284ab483161204c54dfafaa295126e3ba" => :sierra
    sha256 "6d3062ded42a86b5dcea0f2c0d08aca890efe977b11d207a3056f6b3c5c04dc2" => :el_capitan
    sha256 "54a36dc85df0aa86b8bf6295220007441332691d3a99a01977374adb0e0b8327" => :yosemite
  end

  def install
    if build.head?
      system "/bin/sh", "bootstrap.sh"
    else
      system "/bin/sh", "build.sh"
    end
    system "/bin/sh", "install.sh", prefix

    system "bin/nim e install_tools.nims"

    target = prefix/"nim/bin"
    target.install "bin/nimble"
    target.install "dist/nimble/src/nimblepkg"
    target.install "bin/nimgrep"
    target.install "bin/nimsuggest"

    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"
    bin.install_symlink prefix/"nim/bin/nimble"
    bin.install_symlink prefix/"nim/bin/nimgrep"
    bin.install_symlink prefix/"nim/bin/nimsuggest"
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<-EOS.undent
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"", shell_output("#{bin}/nimble dump").split("\n")[0].chomp
  end
end
