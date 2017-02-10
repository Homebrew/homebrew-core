class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20170122.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20170122.tar.bz2"
  sha256 "417e83d9de2fe518a976fcff5a96bffe41421c2a57713cd5272cc89d1072aaa6"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "038d037e61fc290f0eb3c3324fe998758b50afa49e8904ffc4ce6de60e283bc6" => :sierra
    sha256 "a5f4a92db8c6eec8c611443b037684b28f243ba81c472f54a2516a9200fc87d8" => :el_capitan
    sha256 "a5f4a92db8c6eec8c611443b037684b28f243ba81c472f54a2516a9200fc87d8" => :yosemite
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
