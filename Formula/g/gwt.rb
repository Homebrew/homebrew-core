class Gwt < Formula
  desc "Google web toolkit"
  homepage "https://www.gwtproject.org/"
  url "https://github.com/gwtproject/gwt/releases/download/2.12.2/gwt-2.12.2.zip"
  sha256 "32c17bbc8e98548c0be433aab36a3b8ba7428cfc70a26c41c4af4e0d6ecff1e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "82a74ed6f9efb134bb789174581dd637b7986775ec1ced9fac1d24b453e9a609"
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
