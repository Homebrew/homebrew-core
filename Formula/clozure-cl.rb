class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/v1.12.tar.gz"
  sha256 "774a06b4fb6dc4b51dfb26da8e1cc809c605e7706c12180805d1be6f2885bd52"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "44532f82d79ee308886614d8a8ccafd65e049a8621cc7a54a6af15d9985486e7" => :catalina
    sha256 "b17d10463b8101707ad7385a896e3252e6ffd4231c0334ac25aa7967c689226f" => :mojave
    sha256 "3e2a8e6263055e8e21ae373b0def8f4ad5aebaa4e64df12d67b148bbb3fde177" => :high_sierra
  end

  depends_on xcode: :build
  depends_on macos: :catalina # The GNU assembler frontend which ships macOS 10.14 is incompatible with clozure-ccl: https://github.com/Clozure/ccl/issues/271

  # Patch to build heap image with linker shipped with Big Sur.  Remove for next version.
  on_macos do
    if MacOS.version >= :catalina
      patch do
        url "https://github.com/Clozure/ccl/commit/553c0f25f38b2b0d5922ca7b4f62f09eb85ace1c.patch?full_index=1"
        sha256 "deb9e35df75d82c1694fec569a246388485fb64ab7bae3addff6ff3650160b04"
      end
    end
  end

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      url "https://github.com/Clozure/ccl/releases/download/v1.12/darwinx86.tar.gz"
      sha256 "9434fb5ebc01fc923625ad56726fdd217009e2d3c107cfa3c5435cb7692ba7ca"
    end

    on_linux do
      url "https://github.com/Clozure/ccl/releases/download/v1.12/linuxx86.tar.gz"
      sha256 "7fbdb04fb1b19f0307c517aa5ee329cb4a21ecc0a43afd1b77531e4594638796"
    end
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap")

    on_macos do
      buildpath.install tmpdir/"dx86cl64.image"
      buildpath.install tmpdir/"darwin-x86-headers64"
      cd "lisp-kernel/darwinx8664" do
        system "make"
      end
    end

    on_linux do
      buildpath.install tmpdir/"lx86cl64"
      buildpath.install tmpdir/"lx86cl64.image"
      buildpath.install tmpdir/"x86-headers64"
    end

    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    on_macos do
      system "./dx86cl64", "-n", "-l", "lib/x8664env.lisp",
            "-e", "(ccl:xload-level-0)",
            "-e", "(ccl:compile-ccl)",
            "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "dx86cl64.image")\n(quit)\n')
      system "cat image | ./dx86cl64 -n --image-name x86-boot64.image"
    end

    on_linux do
      system "./lx86cl64", "-n", "-l", "lib/x8664env.lisp",
            "-e", "(ccl:rebuild-ccl :full t)",
            "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "lx86cl64.image")\n(quit)\n')
      system "cat image | ./lx86cl64 -n --image-name x86-boot64"
    end

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/scripts/ccl64"]
    bin.env_script_all_files(libexec/"bin", CCL_DEFAULT_DIRECTORY: libexec)
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
