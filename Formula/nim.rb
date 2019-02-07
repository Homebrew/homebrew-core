class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-0.19.4.tar.xz"
  sha256 "f441135ee311099be81a46dba5bab3323579cd18aabc6e079b9697a71d6ca94c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a40e7215b29d7523dd4929af87adc8842cc25cc8a68bbca30fee045c659de91c" => :mojave
    sha256 "537391572332c1bd4c9943aacb6293d2e89292cc3298f4f55f13a80ec3adace7" => :high_sierra
    sha256 "5961ab1c0d76a42f5852d6af85dd9ed8f93694ddb85af2ef2c76626df170554d" => :sierra
  end

  head do
    url "https://github.com/nim-lang/Nim.git", :branch => "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  def install
    if build.head?
      resource("csources").stage do
        system "/bin/sh", "build.sh"
        build_bin = buildpath/"bin"
        build_bin.install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimsuggest/nimble/nimgrep
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix
    bin.install_symlink prefix/"nim/bin/nim"
    bin.install_symlink prefix/"nim/bin/nim" => "nimrod"

    target = prefix/"nim/bin"
    target.install "bin/nimsuggest"
    target.install "bin/nimble"
    target.install "bin/nimgrep"
    bin.install_symlink prefix/"nim/bin/nimsuggest"
    bin.install_symlink target/"nimble"
    bin.install_symlink target/"nimgrep"
  end

  test do
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end
