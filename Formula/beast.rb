class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.4.tar.gz"
  sha256 "e2f8a30e4f695bf0e58ac3e94778459a1db6cd0d476556d86c563e4b6a1181f7"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c894f422a0ee8e3a60a4fc4383b7c92e3373bcddf913034ef92541a346c5d8c" => :mojave
    sha256 "a5c4138c07edad9c5fe6cb2a24c50c3b7e77abfa206f31e0b6d2f6ac62f2fa5b" => :high_sierra
    sha256 "c3b2d7c0e17ee1072e0278ff8cfc4d27cee98450e3b23c29a2e0724c6278def8" => :sierra
  end

  depends_on "ant" => :build
  depends_on "beagle"
  depends_on :java => "1.7+"

  def install
    system "ant", "linux"
    libexec.install Dir["release/Linux/BEASTv*/*"]
    pkgshare.install_symlink libexec/"examples"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    cp pkgshare/"examples/TestXML/ClockModels/testUCRelaxedClockLogNormal.xml", testpath

    # Run fewer generations to speed up tests
    inreplace "testUCRelaxedClockLogNormal.xml", 'chainLength="10000000"',
                                                 'chainLength="100000"'

    system "#{bin}/beast", "testUCRelaxedClockLogNormal.xml"

    %w[ops log trees].each do |ext|
      output = "testUCRelaxedClockLogNormal." + ext
      assert_predicate testpath/output, :exist?, "Failed to create #{output}"
    end
  end
end
