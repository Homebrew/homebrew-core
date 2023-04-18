class Groovyserv < Formula
  desc "Speed up Groovy startup time"
  homepage "https://kobo.github.io/groovyserv/"
  url "https://bitbucket.org/kobo/groovyserv-mirror/downloads/groovyserv-1.2.0-src.zip"
  sha256 "235b38c6bb70721fa41b2c2cc6224eeaac09721e4d04b504148b83c40ea0bb27"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "4f132f1b743be47df84dc7b581b86951379598b3ae260701259e784c516b1a6a"
    sha256 cellar: :any_skip_relocation, mojave:      "576129ad3f5db66baf931af66b60c8c41b0e91929bcbd16c4e05d1ed710415fe"
    sha256 cellar: :any_skip_relocation, high_sierra: "30825c3d2f95214cf8e06fbec819f5b3d1ed87f7b5f0dd1c588525dafaf12c41"
    sha256 cellar: :any_skip_relocation, sierra:      "43388a03d5e69fd6fe8377f8ac51fdfa00ffe0e0276a60f8c7ff2934ab32e2b0"
    sha256 cellar: :any_skip_relocation, el_capitan:  "51aef6e15608021ae127aaa93e2aa39bfaf52cfea688b45841d315b6a04b55aa"
  end

  disable! date: "2022-07-31", because: :does_not_build

  depends_on "go" => :build
  depends_on "groovy"
  depends_on "openjdk@8"

  def install
    # Sandbox fix to stop it ignoring our temporary $HOME variable.
    ENV["GRADLE_USER_HOME"] = buildpath/".brew_home"
    system "./gradlew", "clean", "distLocalBin"
    system "unzip", "build/distributions/groovyserv-#{version}-bin-local.zip"
    libexec.install Dir["groovyserv-#{version}/{bin,lib}"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    system bin/"groovyserver", "--help"
  end
end
