class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "http://ccl.clozure.com/"
  url "http://ccl.clozure.com/ftp/pub/release/1.11/ccl-1.11-darwinx86.tar.gz"
  version "1.11"
  sha256 "2fc4b519f26f7df3fbb62314b15bd5d098082b05d40c3539f8204aa10f546913"
  head "http://svn.clozure.com/publicsvn/openmcl/trunk/darwinx86/ccl"

  bottle :unneeded

  conflicts_with "cclive", :because => "both install a ccl binary"

  def install
    if build.head?
      ENV["CCL_DEFAULT_DIRECTORY"] = buildpath
      system "scripts/ccl64", "-n",
             "-e", "(ccl:rebuild-ccl :full t)",
             "-e", "(quit)"
    end

    # Get rid of all the .svn directories
    rm_rf Dir["**/.svn"]

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
