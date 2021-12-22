class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.0.tar.gz"
  sha256 "674a2617dc11bc7c1a213e97e3266cb169003e9225843ff107388acf4b05c7ad"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78c68887a6ac97efa12172c58829b9c1301d5c9a969e3baa9b989e98fcad14b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22e54986276ba5c5ae9a50b9abc4fff16d88c8337e999c93be624a8e8eb8929f"
    sha256 cellar: :any_skip_relocation, monterey:       "46ff5d789f918121962cb7cfcac5a6c04bb935a968964e07d71d7a55d4eb47ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "591a9e0f427f5a4eb8aa453bc0205be281a76cb6e73567357b397a7b1940a5aa"
    sha256 cellar: :any_skip_relocation, catalina:       "67277cc508c0f6eb530202145c5c11a1314c361c3374f9bd1193d134f36fbeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef386106d8bfb5971790ab2e9266873cedf31ffa21fb80e6c48c531319df15e6"
  end

  depends_on macos: :high_sierra # needs <sys/timex.h>

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{sbin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
