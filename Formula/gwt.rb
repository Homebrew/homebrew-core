class Gwt < Formula
  desc "Google web toolkit"
  homepage "http://www.gwtproject.org/"
  url "https://storage.googleapis.com/gwt-releases/gwt-2.9.0.zip"
  sha256 "253911e3be63c19628ffef5c1082258704e7896f81b855338c6a036f524fbd42"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/gwtproject/gwt.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa7923025737fa93944f4373b92544bacdc5e191b679f1b615b65b0455c2e7a8"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"] # remove Windows cmd files
    libexec.install Dir["*"]

    (bin/"i18nCreator").write_env_script libexec/"i18nCreator", Language::Java.overridable_java_home_env
    (bin/"webAppCreator").write_env_script libexec/"webAppCreator", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"webAppCreator", "sh.brew.test"
    assert_predicate testpath/"src/sh/brew/test.gwt.xml", :exist?
  end
end
