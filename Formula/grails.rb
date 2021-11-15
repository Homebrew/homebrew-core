class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v5.0.1/grails-5.0.1.zip"
  sha256 "e5a1c7de474969165a134decb1d0f7c72cb366e6bedaf2b7ea0d2926c3975489"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71263acd2aa3880c500d608c199c326a05be3812ef329917acbb7fa0636369a4"
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
