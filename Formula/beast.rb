class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.community/"
  url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.2.tar.gz"
  sha256 "7f0d82b15293fcb2778ea39b85c99a973be03566b8ae2deb8d6fc6a58683ffd5"
  head "https://github.com/beast-dev/beast-mcmc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "504311880a8043a22daf1ce8e19310ad7539038c3088b34799908ba40e92eba9" => :mojave
    sha256 "ae61a244730f723a4b4c16ac472fc5f384df4771aedce81f899bd9c99ac3faf3" => :high_sierra
    sha256 "91964c4713e727d24578b55e092ff669820efd7bd74ef397f0b457be82e930db" => :sierra
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
