class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v9.2.0.tar.gz"
  sha256 "fd8eae54016de9055e84fd4251d873bc9a64d0929b02b4355762ce82ab2874b7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "35c03d4159dee347736ad005f035e07fe42efb5f9cd35da2c1df23083951507d"
    sha256 cellar: :any,                 arm64_sonoma:   "4000d689086674fe92eb5becd1734ea706ad7dbfbb8f906161e53e17f27da779"
    sha256 cellar: :any,                 arm64_ventura:  "d840d9a581273c19616d90e839a17ded69effe4f6f66b35bbf2eb00d9af0b77a"
    sha256 cellar: :any,                 arm64_monterey: "ed707ba23b5a2b13b109ca3ddcc1d01488825a0628f105d3872fad075015e97a"
    sha256 cellar: :any,                 sonoma:         "b47572789a8b6f34acf5f1fcca6690260895175f08bc2cba017e7386947c3b70"
    sha256 cellar: :any,                 ventura:        "f25a2dcf5a178f6495f40d0a546212c659646391d7117229883b02bd5e256622"
    sha256 cellar: :any,                 monterey:       "466405f273b24bc6d3e127bd8213dd742b7bdad824c4980251e2cc1af60bd55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34227e49e2a9843381f9aff2d4500302a88e03e5af4ecf867b3b61380f3ee4d1"
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
    url "https://rubygems.org/gems/diff-lcs-1.5.1.gem"
    sha256 "273223dfb40685548436d32b4733aa67351769c7dea621da7d9dd4813e63ddfe"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-22.0.0.gem"
    sha256 "d08a6c228675dd036896bebe82a29750cbdc4dacd461e39edd1199dfa36da719"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-21.3.0.gem"
    sha256 "8177d4e989b6035a4108064e60d806768cbe9040c9740f9cfb872cb40685f673"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-27.0.0.gem"
    sha256 "2e6a8212c1d0107f95d75082e8bd5f05ace4e42dd77a396c7b713be3a8067718"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.5.gem"
    sha256 "534faee5ae3b4a0a6369fe56cd944e907bf862a9209544a9e55f550592c22fac"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-17.0.2.gem"
    sha256 "b1df950bca16843e2948c709592f3b0cf6a20ba4804299e35c30688e15ff4c73"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-6.1.0.gem"
    sha256 "612e521a1ee48495b549f15ae51ecfbfc901ee786245356d38f81c13b6a10ebc"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-13.0.1.gem"
    sha256 "757f9dbfb1e2e0eec19f5fc1091b56a388fb42ba23322be8f10207e6fab3c5c9"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-10.0.1.gem"
    sha256 "bb6e3fcec85c981dff4561997e8675a7123eead5fe9e587d2ad7568adbe18631"
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
