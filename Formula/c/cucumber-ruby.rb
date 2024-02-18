class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v9.1.2.tar.gz"
  sha256 "7f72b2c0708249a30d56829df316d2f5c835bedc06989a83e123e131a8f2b5e2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "499ee20eea101baac7d148363eef821b81f03946607e588fb581ceeec34d713b"
    sha256 cellar: :any,                 arm64_ventura:  "4d480f24f87cfbfd080311c51061651cd7ab50ddbc9a793a01502b20b600dd3d"
    sha256 cellar: :any,                 arm64_monterey: "3612b54e848f1d28dc86196c4ab4d1c25f091cfc5ee74bc3465a37cc8a997148"
    sha256 cellar: :any,                 sonoma:         "5d04748a2aef4d2bb1389a0389e5d31aaafb9c7bdc450f108edb23f2e0409410"
    sha256 cellar: :any,                 ventura:        "f16fac25a40ffd052a75955f5ff25bdb8fa5a508939e8445b2aeb00e1ee26813"
    sha256 cellar: :any,                 monterey:       "fab15cf9f1247c4618c4743cd9903f7a7e99acf1e640d9348cb5bd78b1e36920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e357da1fea39f63f633568ed0092c8cf9aa3e4cd0d1bd3bc060eaea45a600e4"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby" # Requires >= Ruby 2.7

  uses_from_macos "libffi", since: :catalina

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https://rubygems.org/gems/cucumber/versions/9.0.1/dependencies

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.16.3.gem"
    sha256 "6d3242ff10c87271b0675c58d68d3f10148fabc2ad6da52a18123f06078871fb"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.2.3.gem"
    sha256 "63c51d55180828c8e58847eb5c24934eed057f87fb016de6062aa11bf1c5490e"
  end

  resource "multi_test" do
    url "https://rubygems.org/gems/multi_test-1.1.0.gem"
    sha256 "e9e550cdd863fb72becfe344aefdcd4cbd26ebf307847f4a6c039a4082324d10"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.5.0.gem"
    sha256 "49b934001c8c6aedb37ba19daec5c634da27b318a7a3c654ae979d6ba1929b67"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-22.0.0.gem"
    sha256 "d08a6c228675dd036896bebe82a29750cbdc4dacd461e39edd1199dfa36da719"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-21.2.0.gem"
    sha256 "4ee4f8d5dfe9477ec18afa4efd732b86af419f5751813ec62961e5384af89728"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-26.2.0.gem"
    sha256 "9140cbd4535099eca6d4f62677f08c239198771cecd21a18f57ba87f9365c946"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-17.0.1.gem"
    sha256 "0b187308d088a773a1f28eaf23914d27281b1cfb877c810c7c69252fe879db77"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-5.0.6.gem"
    sha256 "4e98a9f78691cbd59c6a1aca6033dfb8bba5905719dbeb4d39c2374708e0ab66"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-12.0.0.gem"
    sha256 "c2a7f4c457dd64df6cc7f430392fb5c03160805eafb27849639fee65d5bb9dfa"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-9.2.0.gem"
    sha256 "98121d128af99883f65b3ab78e987be9d57c17e1adeb79783e4bc269b8592128"
  end

  resource "builder" do
    url "https://rubygems.org/gems/builder-3.2.4.gem"
    sha256 "99caf08af60c8d7f3a6b004029c4c3c0bdaebced6c949165fe98f1db27fbbc10"
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
