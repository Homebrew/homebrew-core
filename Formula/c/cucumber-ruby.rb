class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v9.0.1.tar.gz"
  sha256 "188bf12d3f1867c397815e315da88069be4b8d41c3db9e0f283115afb4dd2575"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5d09d605e0af70a41f048feaa739cfa779da9d1d32cda6be5be074feee921fcb"
    sha256 cellar: :any,                 arm64_monterey: "172d85cf3d5372c1f7fc06e9426a18f50520c2ad37bb8473358885cb6ef62caa"
    sha256 cellar: :any,                 arm64_big_sur:  "7a5c0f9ddf2b30cc460977a8c860e6e809a7c9e4cae12dd9d0a14c09765818af"
    sha256 cellar: :any,                 ventura:        "4a780956fd3e7f946968d28a07e189858dc45b972b65132e6110b5160b5103fa"
    sha256 cellar: :any,                 monterey:       "da66850318280fdb962bb0105a39d0e4a0e31fb822a08ddba6ad608578597c84"
    sha256 cellar: :any,                 big_sur:        "c4f2f05ef49fffb548aab375ace5a63e252d51d3badc214b656ac463fba2bc0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1823a6ee885d11c1a007559907900283b71c6b76d8cb2544c904bdf3c89114e"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby" # Requires >= Ruby 2.7

  uses_from_macos "libffi", since: :catalina

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https://rubygems.org/gems/cucumber/versions/9.0.1/dependencies

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
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
    url "https://rubygems.org/gems/cucumber-messages-21.0.1.gem"
    sha256 "b16000afd9b086a014b7903fe08a2808b700c84340ec256c56c0d7e387510211"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-20.4.0.gem"
    sha256 "badccd4188f9c3b105c8a99b800a065b7d2d2feb406fcfa13b0dc7f59d6285aa"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-26.2.0.gem"
    sha256 "9140cbd4535099eca6d4f62677f08c239198771cecd21a18f57ba87f9365c946"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-16.1.2.gem"
    sha256 "d56f5f2da2b6b07fe4325f702b3d27c4dfda3bb9260c91d50795f285dc570b69"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-4.1.0.gem"
    sha256 "0d279dcaf6af70a8b927202c9d2ca31b5417190c52d0d6c264504dc8c8d33a6c"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-11.1.0.gem"
    sha256 "4b5a76518555f97be0e7220011a593462941c7dbd225e610f0f1f7ccf5f4b90a"
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
