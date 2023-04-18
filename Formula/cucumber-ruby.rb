class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v8.0.0.tar.gz"
  sha256 "5e382fc00fd04842813f58c7c7a1b43c2ddf6a8e5c53ae9916daba95462cdb6a"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_ventura:  "63a75468e73e8201f581fb08ff5e7d23a0d31a3263d4c4d8156e2837c7098288"
    sha256                               arm64_monterey: "c674a1582276891fbb6592041f5ffc2423e3a0ba869cef1fd0e7d5d0349329a4"
    sha256                               arm64_big_sur:  "f922affbd0e4c738a0bbcafed5b9ca426336029b24f91ce248535afc17c03084"
    sha256                               ventura:        "d20731d327188d4a02c1059d2aaf4599be99b32d8931571b7e727cd31feb33d3"
    sha256                               monterey:       "aeca1ff5682acee4d1c8305ceb49a607861a32da7f4492b3d152380a1012d643"
    sha256                               big_sur:        "082843d29dedbe24c41520c52f39929e02d0be6b6e93931c870f713f69e5b063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d25c5b6a9261e9488adcd3885bd186d498ff5056473f3de6095c82793be6828"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :big_sur

  resource "builder" do
    url "https://rubygems.org/gems/builder-3.2.4.gem"
    sha256 "99caf08af60c8d7f3a6b004029c4c3c0bdaebced6c949165fe98f1db27fbbc10"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-9.1.0.gem"
    sha256 "6702db7ba25d41b9f8c164752c97d38ceca2f4e670649fd9fb6a51991d14b6da"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-11.0.0.gem"
    sha256 "300f0b27e54cee4167ad4930ccc6fbd9477fbcee31f9730084ac96cf0a4f2f37"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-15.2.0.gem"
    sha256 "7218e9253e69e3ab18b0b9d0be7a17209251c612b85c026de444dc64fc7db393"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-23.0.1.gem"
    sha256 "92239a6be4d32cc4639204f739134ec40d0c7f119a29fb0726213074bc645b37"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-19.2.0.gem"
    sha256 "dfb3b8d296e60c45f437c8cfde2990b62a2fa15afa0b44fae718fb4772a8d5be"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-18.0.0.gem"
    sha256 "fb494f870166b2dabd7342b53bfa880088f4257039e7784b58eae0e9fb5c0ac5"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-4.1.0.gem"
    sha256 "0d279dcaf6af70a8b927202c9d2ca31b5417190c52d0d6c264504dc8c8d33a6c"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.5.0.gem"
    sha256 "49b934001c8c6aedb37ba19daec5c634da27b318a7a3c654ae979d6ba1929b67"
  end

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
  end

  resource "mime-types" do
    url "https://rubygems.org/gems/mime-types-3.4.1.gem"
    sha256 "6bcf8b0e656b6ae9977bdc1351ef211d0383252d2f759a59ef4bcf254542fc46"
  end

  resource "mime-types-data" do
    url "https://rubygems.org/gems/mime-types-data-3.2022.0105.gem"
    sha256 "d8c401ba9ea8b648b7145b90081789ec714e91fd625d82c5040079c5ea696f00"
  end

  resource "multi_test" do
    url "https://rubygems.org/gems/multi_test-1.1.0.gem"
    sha256 "e9e550cdd863fb72becfe344aefdcd4cbd26ebf307847f4a6c039a4082324d10"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.2.2.gem"
    sha256 "4c26d36b66746872a14b050015f4c22ce43f493a205ab1eeb50054976711663e"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      # Fix segmentation fault on Apple Silicon
      # Ref: https://github.com/ffi/ffi/issues/864#issuecomment-875242776
      args += ["--", "--enable-libffi-alloc"] if r.name == "ffi" && OS.mac? && Hardware::CPU.arm?
      system "gem", "install", r.cached_download, *args
    end
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "--ignore-dependencies", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_predicate testpath/"features", :exist?
  end
end
