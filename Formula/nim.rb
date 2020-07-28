class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-1.2.4.tar.xz"
  sha256 "eef18f32fabe65f0d06a40f32e297d1f6daba66463c33f3ab57edc4d3530d636"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9893915c7306617053c8e74b383315a573d624e396e1fa9c9bef069446d29b5" => :catalina
    sha256 "206367c0fec082a793187aff91fe92cb350cd95db78ec96d844d488ee4e88a64" => :mojave
    sha256 "57cfb08ba8102472526a48cb9870b8a2ce32fd864ff10c9a833c8d78aac70766" => :high_sierra
  end

  head do
    url "https://github.com/nim-lang/Nim.git", branch: "devel"
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
