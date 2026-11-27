class Gwt < Formula
  desc "Google web toolkit"
  homepage "https://www.gwtproject.org/"
  url "https://github.com/gwtproject/gwt/releases/download/2.13.1/gwt-2.13.1.zip"
  sha256 "92610f2f9b929a8625b858fe394c15351357ba32733282e79e38168ecc0d131d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "fbc5c4803c2e517cd66c84c7ac0c31f8a70b4c54218b6c5794244fe56df3c430"
    sha256 cellar: :any_skip_relocation, all: "d14dc605a4b0a4628bb6b2df67684e850e32f7fa02cf12c1da4559fcaeecc189"
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
    assert_path_exists testpath/"src/sh/brew/test.gwt.xml"
  end
end
