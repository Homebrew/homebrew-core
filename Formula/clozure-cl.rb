class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com/"
  url "https://github.com/Clozure/ccl/archive/v1.11.5.tar.gz"
  sha256 "07c7e05c1d50ccbf1f7602a1d436b6d6da5dcda7656b89b74daa4cf833fc7929"
  head "https://github.com/Clozure/ccl.git"

  bottle :unneeded

  conflicts_with "cclive", :because => "both install a ccl binary"

  resource "bootstrap" do
    url "https://github.com/Clozure/ccl/releases/download/v1.11.5/ccl-1.11.5-darwinx86.tar.gz"
    version "1.11.5"
    sha256 "5adbea3d8b4a2e29af30d141f781c6613844f468c0ccfa11bae908c3e9641939"
  end

  def install
    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    buildpath.install resource("bootstrap")

    system "scripts/ccl64", "-n",
           "-e", "(ccl:rebuild-ccl :full t)",
           "-e", "(quit)"

    prefix.install "doc/README"
    doc.install Dir["doc/*"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/scripts/ccl{,64}"]
    bin.env_script_all_files(libexec/"bin", :CCL_DEFAULT_DIRECTORY => libexec)
  end

  test do
    args = "-n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'"
    %w[ccl ccl64].each do |ccl|
      assert_equal "21", shell_output("#{bin}/#{ccl} #{args}").strip
    end
  end
end
