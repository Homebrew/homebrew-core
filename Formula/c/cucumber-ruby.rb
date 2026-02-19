class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "f17b66f2bbae36e883f4c943a6426529023c42946ea102df6e219e2874bd28aa"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cf2ccf4fe38a1c09c019d1ebfb7955ce1ea5e330400328680c2975ce1ac4ff1"
    sha256 cellar: :any,                 arm64_sequoia: "30e5c4e01d3866c6887a3420ce745e5a7a8f8f0f21a30c51356d2c0d07cf829f"
    sha256 cellar: :any,                 arm64_sonoma:  "e67286b5fc56a8d1c99a93abafe9054e82f80d86297594302348fd5ba16aae84"
    sha256 cellar: :any,                 sonoma:        "1c23a1fcfe5abd9db2f022bccba150a00e87a522e9fcfcff9fd961098aa34da1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68d3a954bfb692028094fb34b0bb1bb44b569bf6d70415d60099ac10d6697d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96fd0490409f57b755577457a05084e1bd32be304a2d1b61d8af82d9663e208a"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber -v #{version}`
  # https://rubygems.org/gems/cucumber/versions/#{version}/dependencies

  resource "memoist3" do
    url "https://rubygems.org/downloads/memoist3-1.0.0.gem"
    sha256 "686e42402cf150a362050c23143dc57b0ef88f8c344943ff8b7845792b50d56f"
  end

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.17.2.gem"
    sha256 "297235842e5947cc3036ebe64077584bff583cd7a4e94e9a02fdec399ef46da6"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.4.1.gem"
    sha256 "ed2278ec670ee8af5eb5420d3a98e22188051f6241180db7c779993db2739a16"
  end

  resource "multi_test" do
    url "https://rubygems.org/gems/multi_test-1.1.0.gem"
    sha256 "e9e550cdd863fb72becfe344aefdcd4cbd26ebf307847f4a6c039a4082324d10"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.6.2.gem"
    sha256 "9ae0d2cba7d4df3075fe8cd8602a8604993efc0dfa934cff568969efb1909962"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-29.0.1.gem"
    sha256 "77bd8ad859ae35fd4e076cd32fce940963317e17229dd51c7844ac11766a6cb9"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-22.2.0.gem"
    sha256 "e92fed01ee5a120690da89152ddbe71b77aa56b058228f9df81c6bf8cd4b6980"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.3.1.gem"
    sha256 "eaa01e228be54c4f9f53bf3cc34fe3d5e845c31963e7fcc5bedb05a4e7d52218"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-18.0.1.gem"
    sha256 "8398a0bf636af33ff3b61e459a309295eb02745b9e21bd7af0eaaa2a1e6be3e5"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-8.1.0.gem"
    sha256 "9bd8c4b6654f8e5bf2a9c99329b6f32136a75e50cd39d4cfb3927d0fa9f52e21"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-36.1.0.gem"
    sha256 "c2b8e950fc3dc0b19d7fd59bb5e47950dbe61129bffcf3c038fcacaea7942b09"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-15.4.0.gem"
    sha256 "161309d85847b336c998b201e2003d3f4a86207fa4816da2678fe3d7f3735e45"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-11.0.0.gem"
    sha256 "0df79a9e1d0b015b3d9def680f989200d96fef206f4d19ccf86a338c4f71d1e2"
  end

  resource "builder" do
    url "https://rubygems.org/gems/builder-3.3.0.gem"
    sha256 "497918d2f9dca528fdca4b88d84e4ef4387256d984b8154e9d5d3fe5a9c8835f"
  end

  resource "base64" do
    url "https://rubygems.org/gems/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "--ignore-dependencies", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match(/creating\s+features/, shell_output("#{bin}/cucumber --init"))
    assert_path_exists testpath/"features"
  end
end
