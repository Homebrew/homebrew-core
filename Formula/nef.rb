class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://github.com/bow-swift/nef"
  url "https://github.com/bow-swift/nef/archive/0.5.2.tar.gz"
  sha256 "050181c1e541e54428f8214092b17a321fb1e4f2460ae2bd8115063637244b02"

  depends_on :xcode => "11.0"

  def version
    "0.5.2"
  end

  def install
    build_project

    bin.install "./bin/nef"
    bin.install "./bin/nef-common"
    bin.install "./bin/nefc"
    bin.install "./bin/nef-playground"
    bin.install "./bin/nef-markdown-page"
    bin.install "./bin/nef-markdown"
    bin.install "./bin/nef-jekyll-page"
    bin.install "./bin/nef-jekyll"
    bin.install "./bin/nef-carbon-page"
    bin.install "./bin/nef-carbon"
    bin.install "./bin/nef-playground-book"
  end

  def build_project
    system "swift", "build", "--disable-sandbox", "--package-path", "project", "--configuration", "release", "--build-path", "release"
    cp "./release/x86_64-apple-macosx/release/nef-markdown-page", "./bin"
    cp "./release/x86_64-apple-macosx/release/nef-jekyll-page", "./bin"
    cp "./release/x86_64-apple-macosx/release/nef-carbon-page", "./bin"
    cp "./release/x86_64-apple-macosx/release/nef-playground-book", "./bin"
  end

  test do
    project = "#{project_path}"
    chdir(project)

    tests = shell_output("swift test --disable-sandbox --package-path #{project}/project --configuration debug --build-path tests 2>&1")
    nef = shell_output("#{bin}/nef --version")
    markdown = shell_output("#{bin}/nef markdown --project #{project}/Documentation.app --output #{HOMEBREW_TEMP}/nef-test-markdown")
    jekyll = shell_output("#{bin}/nef jekyll --project #{project}/Documentation.app --main-page #{project}/Documentation.app/jekyll/Home.md --output #{HOMEBREW_TEMP}/nef-test-jekyll")

    assert_match "'All tests' passed", tests
    assert_match "#{version}", nef
    assert_match "✅", markdown
    assert_match "✅", jekyll
  end

  def project_path
    chdir("#{HOMEBREW_TEMP}")
    url = "https://github.com/bow-swift/nef/archive/#{version}.tar.gz"
    cleanUp = shell_output("rm -rf #{HOMEBREW_TEMP}/nef*")
    donwloadProject = shell_output("curl -L #{url} --output #{HOMEBREW_TEMP}/nef-#{version}.tar.gz")
    unzipProject = shell_output("tar xzf #{HOMEBREW_TEMP}/nef-#{version}.tar.gz")

    "#{HOMEBREW_TEMP}/nef-#{version}"
  end

end
