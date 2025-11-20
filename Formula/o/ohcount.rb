class Ohcount < Formula
  desc "Source code line counter"
  homepage "https://github.com/blackducksoftware/ohcount"
  url "https://github.com/blackducksoftware/ohcount/archive/refs/tags/4.0.0.tar.gz"
  sha256 "d71f69fd025f5bae58040988108f0d8d84f7204edda1247013cae555bfdae1b9"
  license "GPL-2.0-only"
  head "https://github.com/blackducksoftware/ohcount.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e44046c903fb421bf44b7dc8a9a4862d4cda4c7530dd3c6f6fd5c4e2f375b1ed"
    sha256 cellar: :any,                 arm64_sequoia:  "d537aa1e6a4a264ac45a9fa154b6dc8d0fdfae03fafe2cc2f81cdd4396aa5769"
    sha256 cellar: :any,                 arm64_sonoma:   "27c7e0899c7845d03e7f17f2a97f2fa6e47a6923fb1c232ce50551cd5a95122a"
    sha256 cellar: :any,                 arm64_ventura:  "2651774c46561b5dd0c6b71c9db1776367cbd6f31b83471abbe4ba54a92499c8"
    sha256 cellar: :any,                 arm64_monterey: "4d5cc69e38917712d81bfb15e4cd044af67b6fdc3b4229e6030656dca705e8c6"
    sha256 cellar: :any,                 arm64_big_sur:  "43a0bac3974271a961f6cbb035aeb37e0f63e6fc05200bdf8b28064ca7faf128"
    sha256 cellar: :any,                 sonoma:         "8bfe6b81dc3efdb8efbb539e73d09ce97372a216269a3cdc64248d28da641a45"
    sha256 cellar: :any,                 ventura:        "2aa5b5bd949c86b0a05afe668a3d840d42e6a5c6797d7115eac0670623d2589c"
    sha256 cellar: :any,                 monterey:       "c536c13d4e615310df75e452d175b13fc036fde61675adba34b89851097ad814"
    sha256 cellar: :any,                 big_sur:        "4c6dbf352f569f3976b9c3992376f9afbd4cc05ceb1bbf129b4e462628dbe618"
    sha256 cellar: :any,                 catalina:       "49de65862c42d1e653b84aa09a3ca9015de5afa40d9c1069d5a7f5a4e35060e5"
    sha256                               arm64_linux:    "e5b7f38361c5247632be1f37eae14d3d1fee98d4a35c3feb6864e699300f2fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d8342b2b51c283aa66ab2c23b79ad9bc4a98c6c2d93bb8ae857a63fbe1f23b"
  end

  depends_on "gperf" => :build
  depends_on "libmagic"
  depends_on "pcre"
  depends_on "ragel"

  def install
    system "./build", "ohcount"
    bin.install "bin/ohcount"
  end

  test do
    (testpath/"test.rb").write <<~RUBY
      # comment
      puts
      puts
    RUBY
    stats = shell_output("#{bin}/ohcount -i test.rb").lines.last
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
  end
end
