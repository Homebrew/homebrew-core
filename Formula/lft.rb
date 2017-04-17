class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.79.tar.gz"
  sha256 "08e5c7973551b529c850bffbc7152c4e5f0bcb1f07ebbb39151a7dc9a3bf9de0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e024fb99a6de1ccc416f7a87d7c44ebcabcd854bf66c5ba9d8a8c67969a3b02" => :sierra
    sha256 "3282198e61767e578d7b5fc5123f4657093b331954e7ab6d02aaab723b24b35c" => :el_capitan
    sha256 "170bcc6b837eac788cac1995632308210617628325e51ee1b9b0d255755e03cd" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lft -v 2>&1")
  end
end
