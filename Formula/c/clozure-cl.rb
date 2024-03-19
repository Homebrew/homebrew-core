class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "7f424c52041486dde91e32726f919a16fb1d7272d2a6e404673ae63e04f2d185"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "49bbd4b8343312ec9c624c25a93e6a372b0c58027a6ada5d1bb0ab050736c5a9"
    sha256 cellar: :any_skip_relocation, ventura:      "662e440dda7b6d62329b02bdbbe683bd48dd608c70e6a3841e18ded69a4cea0f"
    sha256 cellar: :any_skip_relocation, monterey:     "9bad448a48e4a5c8774d1bff451009c66bf3a8aba6871eb931827b5fc2ffe25b"
    sha256 cellar: :any_skip_relocation, big_sur:      "1cd8f8a8e010db33aa548a9430b43d4ae95b4f1b56999862e648988269751cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d407dd6707dfcdf729e567c7a8099ad3d8b9e355ee9c9960a49b2bdab2ceab36"
  end

  # https://github.com/Clozure/ccl/issues/11
  depends_on xcode: :build
  depends_on arch: :x86_64
  depends_on macos: :catalina # The GNU assembler frontend which ships macOS 10.14 is incompatible with clozure-ccl: https://github.com/Clozure/ccl/issues/271

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      url "https://github.com/Clozure/ccl/releases/download/v1.12.2/darwinx86.tar.gz"
      sha256 "428406380e64e42b1a5c202b7da807bfe8a5de507a466ad873f6292e389b1b2b"
    end

    on_linux do
      url "https://github.com/Clozure/ccl/releases/download/v1.12.2/linuxx86.tar.gz"
      sha256 "782bcf2e92c6b8ca5207826bbd05a65557f22b9f1194cc4a7caa38f62de83eac"
    end
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap")

    if OS.mac?
      buildpath.install tmpdir/"dx86cl64.image"
      buildpath.install tmpdir/"darwin-x86-headers64"
      cd "lisp-kernel/darwinx8664" do
        system "make"
      end
    else
      buildpath.install tmpdir/"lx86cl64"
      buildpath.install tmpdir/"lx86cl64.image"
      buildpath.install tmpdir/"x86-headers64"
    end

    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    if OS.mac?
      system "./dx86cl64", "-n", "-l", "lib/x8664env.lisp",
            "-e", "(ccl:xload-level-0)",
            "-e", "(ccl:compile-ccl)",
            "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "dx86cl64.image")\n(quit)\n')
      system "cat image | ./dx86cl64 -n --image-name x86-boot64.image"
    else
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
