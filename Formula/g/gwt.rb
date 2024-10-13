class Gwt < Formula
  desc "Google web toolkit"
  homepage "https://www.gwtproject.org/"
  url "https://github.com/gwtproject/gwt/releases/download/2.11.0/gwt-2.11.0.zip"
  sha256 "44d83cd0eb32d857f197e9e76f0fdf79f1ed240b47173bafeeaf8db2b5ad205c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "eb87a6195740729c45e945d12e0dd004824713dc2f5396e67061aee7c6d92743"
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
