class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.0.0.tar.xz"
  sha256 "034817cc4dec86b7099bcf3e79e9e38842b50212b2fd96cd741fe90855a7e0dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "99dc7109355f188aeeb3fcafd364d8737de184dbe31894bc136272e5624f3aaa" => :mojave
    sha256 "52ece02a2308fbd9584f1a960f28fd888f9f4cb8b482824dc120c9a0d61b556a" => :high_sierra
    sha256 "92379c9a9554e93f90228bfba8d1e0eabecf85bed4d3e3a7cd43b2a81d5363c6" => :sierra
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
        (buildpath/"bin").install "bin/nim"
      end
    else
      system "/bin/sh", "build.sh"
    end
    # Compile the koch management tool
    system "bin/nim", "c", "-d:release", "koch"
    # Build a new version of the compiler with readline bindings
    system "./koch", "boot", "-d:release", "-d:useLinenoise"
    # Build nimble/nimgrep/nimpretty/nimsuggest
    system "./koch", "tools"
    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
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
