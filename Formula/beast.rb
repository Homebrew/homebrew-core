class Beast < Formula
  desc "Bayesian Evolutionary Analysis Sampling Trees"
  homepage "http://beast.community/"
  head "https://github.com/beast-dev/beast-mcmc.git"

  stable do
    url "https://github.com/beast-dev/beast-mcmc/archive/v1.10.1.tar.gz"
    sha256 "bceed133e21fcde567a6c32e3fc4a07ef77791c5b48fb01769bb2a6431edcb5f"

    # Fix build system on 1.10.1. Remove after next release
    patch do
      url "https://github.com/beast-dev/beast-mcmc/commit/0b6ab7d5771648051e430579c4baa51aea497c65.patch?full_index=1"
      sha256 "0db99329d47062d0e507c5387d5dacbb44c83273ec2e5e30ee18bc7adba2c9de"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eceff45849a4b799c9f0d590b2746c1b2764e09a0abec1fdd7c803a9b16bd59c" => :mojave
    sha256 "18363f90761d465aa9b3e1a2e37b884fcc2361fbb927cb5d91184eb92fc3c0d7" => :high_sierra
    sha256 "3440a01630e7673369720258960618b4c0f0f8305775151b62e8b50818208675" => :sierra
    sha256 "b11b1291e5a960aaf77bef07542f9e7a9b0da2e8fb24a24da3fa8c12a07381ee" => :el_capitan
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
