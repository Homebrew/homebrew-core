class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v6.1.2/grails-6.1.2.zip"
  sha256 "3e889766e0096cab3205155ac70b0a4838750733d89600307bfc42d2a7de0e0b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d61c73ef3bdf952eb04142fda9cef6f2268f8011b8af16d4d1f4796dc7c0fe9e"
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
