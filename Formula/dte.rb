class Dte < Formula
  desc "Small and easy to use console text editor"
  homepage "https://craigbarnes.gitlab.io/dte/"
  url "https://github.com/craigbarnes/dte/releases/download/v1.6/dte-1.6.tar.gz"
  sha256 "07a1f39831aa26c23ff635ab440983d84162156da199eaa06f0cb75149a9bbf4"
  head "https://github.com/craigbarnes/dte.git"

  def install
    system "make", "-j#{ENV.make_jobs}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dte -V")
    assert_match "syntax/ruby", shell_output("#{bin}/dte -B")
  end
end
