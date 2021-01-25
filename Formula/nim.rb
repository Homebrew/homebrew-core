class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.4.2.tar.xz"
  sha256 "03a47583777dd81380a3407aa6a788c9aa8a67df4821025770c9ac4186291161"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0bd46ce2277fd158cc74f3ff1b628a043602048a45cc5a8308a9555fafb950c" => :big_sur
    sha256 "b7c2cde81c13442221e9145469d36bc3bfb97ee75b41cc34e5be42d09a8688cc" => :catalina
    sha256 "55f94a676d4b5c3c362cb61866a19915ef6bd146dc9b8b601b89c69fcf4808bd" => :mojave
  end

  head do
    url "https://github.com/nim-lang/Nim.git", branch: "devel"
    resource "csources" do
      url "https://github.com/nim-lang/csources.git"
    end
  end

  depends_on "help2man" => :build

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

    system "help2man", "bin/nim", "-o", "nim.1", "-N"
    man1.install "nim.1"

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      man1.install "#{t}.1"
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
