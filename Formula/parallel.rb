class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20190422.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20190422.tar.bz2"
  sha256 "b44bedadff56936f05995ca54628a45ff528df5a59e37affb8f2ee00ad2bb475"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc268738fabe09f5e5a5e34733d6ec15bee4130112062547144b308c8dc37cda" => :mojave
    sha256 "bc268738fabe09f5e5a5e34733d6ec15bee4130112062547144b308c8dc37cda" => :high_sierra
    sha256 "91433571207bcc053c88106e4a5037e137d6bb90c6e9cbcc8a2813d5099a3c28" => :sierra
  end

  if Tab.for_name("moreutils").with?("parallel")
    conflicts_with "moreutils",
      :because => "both install a `parallel` executable."
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
