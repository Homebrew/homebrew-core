class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.0.tar.gz"
  sha256 "5c77d0dab496489d1418d562a4ef90710f9ff70628a35e6089269605788953df"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2ac18914ff4796b0ebf2d8dd957d3ae7cab960ce54b7708f97555199fbb135d" => :high_sierra
    sha256 "5415f2f49a9bb8ff4b5b8078b1df6dcfc76043e3d9fd29d0ed4baaf7349a4418" => :sierra
    sha256 "e27eb22cbfde02b27d6354b1c6a532be88ac5ac2168353d59ae15fae477ba71e" => :el_capitan
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
