class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20180722.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20180722.tar.bz2"
  sha256 "cf0d421cd78c58741395f94f568c33a0fe409bd5f4bd45f1ae804ec2d32dc318"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1c92d1464090869ea5327e8b2cf69683cda7475dbae580ff0ed286e28232564" => :high_sierra
    sha256 "c1c92d1464090869ea5327e8b2cf69683cda7475dbae580ff0ed286e28232564" => :sierra
    sha256 "c1c92d1464090869ea5327e8b2cf69683cda7475dbae580ff0ed286e28232564" => :el_capitan
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
