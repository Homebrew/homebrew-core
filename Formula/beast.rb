class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.bio.ed.ac.uk/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.8.4.tar.gz"
  sha256 "de8e7dd82eb9017b3028f3b06fd588e5ace57c2b7466ba2e585f9bd8381407af"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d04adbad7f141cc0e7465855a098e46c4c156e1ac59a400911e67ee1c62571d" => :high_sierra
    sha256 "fd0b8225774ad857e296ca5fe8540ab21de86a5e951d963e2af5473f6e85a5e2" => :sierra
    sha256 "30fa27c365bed00f62c399e7724044bfc2eef0e211ca7ca41211d01446c7a27d" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on :java => "1.7+"

  def install
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    cp pkgshare/"examples/clockModels/testUCRelaxedClockLogNormal.xml", testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml", 'chainLength="10000000"',
                                                 'chainLength="100000"'

    system "#{bin}/beast", "-beagle_off", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_predicate testpath/output, :exist?, "Failed to create #{output}"
    end
  end
end
