class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.3.tar.gz"
  sha256 "16dbccbc5d88e8a66b87ded34cf6370139b60b998f48bd603869e84ea79794ec"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f49c97db13463e710043cddd71e390b6c0269cc9450f15b6a03acc6640e1748d" => :mojave
    sha256 "0010bec81cad92223de7397ce0aa31ad36143934c92f453de1b4ceb36483db94" => :high_sierra
    sha256 "7b60597acedc5dfd8aa1d36fd98adefb197c5db2172e72139769d822caecdd28" => :sierra
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
