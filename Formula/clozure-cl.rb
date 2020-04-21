class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/v1.12.tar.gz"
  sha256 "774a06b4fb6dc4b51dfb26da8e1cc809c605e7706c12180805d1be6f2885bd52"
  head "https://github.com/Clozure/ccl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8725b08fc19b2330d25b78d56d06564b01f8c70ec09763a5a6823db05b81d928" => :mojave
    sha256 "06426d4b5d6f5875734eac8d6bac1e1a99e37b6ca26696d458274eb36b23e8b0" => :high_sierra
    sha256 "f4bbb8190f307cfc272e80879e88c51e1ca8bf9382fcf93b0cc628e7169fe522" => :sierra
  end

  depends_on :xcode => :build

  resource "bootstrap" do
    url "https://github.com/Clozure/ccl/releases/download/v1.12/darwinx86.tar.gz"
    sha256 "9434fb5ebc01fc923625ad56726fdd217009e2d3c107cfa3c5435cb7692ba7ca"
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap")
    buildpath.install tmpdir/"dx86cl64.image"
    buildpath.install tmpdir/"darwin-x86-headers64"
    cd "lisp-kernel/darwinx8664" do
      args = []

      if DevelopmentTools.clang_build_version == 1100 && MacOS::CLT.installed?
        # Xcode 11.0-11.3 assembler is broken. Try the CLT in case it is older.
        # https://github.com/Clozure/ccl/issues/271
        # Note: ccl NEEDS the system assembler - it is not compatible with Clang's
        args << "AS=/Library/Developer/CommandLineTools/usr/bin/as"
      end

      system "make", *args
    end

    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    system "./dx86cl64", "-n", "-l", "lib/x8664env.lisp",
                         "-e", "(ccl:xload-level-0)",
                         "-e", "(ccl:compile-ccl)",
                         "-e", "(quit)"
    (buildpath/"image").write('(ccl:save-application "dx86cl64.image")\n(quit)\n')
    system "cat image | ./dx86cl64 -n --image-name x86-boot64.image"

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/scripts/ccl64"]
    bin.env_script_all_files(libexec/"bin", :CCL_DEFAULT_DIRECTORY => libexec)
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
