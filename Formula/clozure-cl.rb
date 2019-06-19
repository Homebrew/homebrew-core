class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/v1.11.6.tar.gz"
  sha256 "6a496d35e05dc3e6e7637884552b1f14c82296525546f28337b222e4c3d7d50b"
  head "https://github.com/Clozure/ccl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab7c724028ac881bbff74bbc692d51e2afaf7f912930520e3e8c78063e5a37b9" => :high_sierra
    sha256 "89b7b51d2b1ed683182f3585101bbf101dad10d2c851f383dbec7e1342162cd7" => :sierra
    sha256 "6cb7aa8d20a8657bc70cd35cce042cd50841b7d2b2533ff233ecbd8fae2e6a49" => :el_capitan
  end

  depends_on :xcode => :build

  conflicts_with "cclive", :because => "both install a ccl binary"

  resource "bootstrap" do
    url "https://github.com/Clozure/ccl/releases/download/v1.11.5/ccl-1.11.5-darwinx86.tar.gz"
    sha256 "5adbea3d8b4a2e29af30d141f781c6613844f468c0ccfa11bae908c3e9641939"
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap")
    buildpath.install tmpdir/"dx86cl64.image"
    buildpath.install tmpdir/"darwin-x86-headers64"
    cd "lisp-kernel/darwinx8664" do
      system "make"
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
