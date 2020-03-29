class Colorsvn < Formula
  desc "Subversion output colorizer"
  homepage "http://colorsvn.tigris.org/"
  url "http://colorsvn.tigris.org/files/documents/4414/49311/colorsvn-0.3.3.tar.gz"
  sha256 "db58d5b8f60f6d4def14f8f102ff137b87401257680c1acf2bce5680b801394e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "fb2e7d5ebe86b5c758a88cc06fe9e79c0b6b7bb86153fe116380d9c7875b6355" => :catalina
    sha256 "46d8260b22e8a86b2bb573bffff4c6b8cea06dd8e3b2fe7e35e4b66960eb38ee" => :mojave
    sha256 "4135712b5dd13e852b9c3ec5b7e95f22f5ec89e28e9f600a9372bd260b2851cf" => :high_sierra
    sha256 "5c56662f331161022c31f665d980e077d6a01328864c6c59c137de3b0b57e4f2" => :sierra
    sha256 "bf4048c281332c5cfcae4fc74c0fa233ad84c3fe2c111e633101d593284fe601" => :el_capitan
    sha256 "88c79f8a9bc43d118449ce9d97061af4633f15f942a0a48caef5e1b327aea0e5" => :yosemite
    sha256 "2711d058fa4c892f350b6309a82f7eeb85455bc1b336afc75587c467121a553d" => :mavericks
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/colorsvn/0.3.3.patch"
    sha256 "2fa2c40e90c04971865894933346f43fc1d85b8b4ba4f1c615a0b7ab0fea6f0a"
  end

  def install
    # `configure` uses `which` to find the `svn` binary that is then hard-coded
    # into the `colorsvn` binary and its configuration file. Unfortunately, this
    # picks up our SCM wrapper from `Library/ENV/` that is not supposed to be
    # used outside of our build process. Do the lookup ourselves to fix that.
    svn_binary = which_all("svn").reject do |bin|
      bin.to_s.start_with?("#{HOMEBREW_REPOSITORY}/Library/ENV/")
    end.first
    inreplace ["configure", "configure.in"], "\nORIGSVN=`which svn`",
                                             "\nORIGSVN=#{svn_binary}"

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    inreplace ["colorsvn.1", "colorsvn-original"], "/etc", etc
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You probably want to set an alias to svn in your bash profile.
      So source #{etc}/profile.d/colorsvn-env.sh or add the line

          alias svn=colorsvn

      to your bash profile.

      So when you type "svn" you'll run "colorsvn".
    EOS
  end

  test do
    assert_match /svn: E155007/, shell_output("#{bin}/colorsvn info 2>&1", 1)
  end
end
