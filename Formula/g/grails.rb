class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v6.0.0/grails-6.0.0.zip"
  sha256 "2e1d1b7d4d40fdd790893ba78c66e112b77c197895c0224223772ebc29554535"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, ventura:        "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, monterey:       "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad002a03561858bcdc20c3922ec58a8bda981f204d630ebca03dd72f66e3b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5bf81ef6be6f46ceb070b6b07908027006988721b714c801bbc975a22e0eaff"
  end

  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    system bin/"grails", "create-app", "brew-test"
    assert_predicate testpath/"brew-test/gradle.properties", :exist?
    assert_match "brew.test", File.read(testpath/"brew-test/build.gradle")

    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails -v")
  end
end
