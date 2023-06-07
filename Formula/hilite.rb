class Hilite < Formula
  desc "CLI tool that runs a command and highlights STDERR output"
  homepage "https://sourceforge.net/projects/hilite/"
  url "https://downloads.sourceforge.net/project/hilite/hilite/1.5/hilite.c"
  sha256 "e15bdff2605e8d23832d6828a62194ca26dedab691c9d75df2877468c2f6aaeb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2fa393a2cd13f75d3793c7d543ae3fd5a053cdfdd82ac722015912618fa596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f3e960b26ed8e81acab99dd342d1e2946b1ec8003fb99dd65b91add5af31c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4095517387a97c332c1acb88969995248ee95d2c29483e56ed7e47bbb8ca721"
    sha256 cellar: :any_skip_relocation, ventura:        "5316dcf6b7f26ecf9a6149a3db6026a9b1c467f35af63e2dcd499f0262c3db52"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5bf78c282a2858319b08bcfcc65af8be02431aeae83ac6654b32cc7c3bb605"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f3139534dda449285ab33db2042a264bc553b7efa47ac86507b598c50a5a2d7"
    sha256 cellar: :any_skip_relocation, catalina:       "31205045cec574039eca74d90f2701191f1192726943e5f7bbc37d1081e21c3e"
    sha256 cellar: :any_skip_relocation, mojave:         "0b25a0fe83ce681fab4f9a0a3f7989528387e299cd6fc507eeb9b24e8f2b1490"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0266c20b3be69d398a14f1cb9332d34fe9ffca36c827b6e3681b636c0eab6073"
    sha256 cellar: :any_skip_relocation, sierra:         "b4bab9fd50310b7401d2605b9a9cdad0a8d7069e5b477d5f53fef61847bea624"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2c407d12952089ade6602be85acda46eceb3127e32ba2068c0034df8a486e989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f0c131886b8932ee87061c612877ff71fa38650e81340eab5694de95e6cb40"
  end

  def install
    system ENV.cc, "hilite.c", "-o", "hilite", *ENV.cflags.to_s.split
    bin.install "hilite"
  end

  test do
    system "#{bin}/hilite", "bash", "-c", "echo 'stderr in red' >&2"
  end
end
