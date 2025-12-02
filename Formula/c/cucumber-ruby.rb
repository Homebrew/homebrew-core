class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v10.1.1.tar.gz"
  sha256 "fa45ef239cce94bf1d2455b9afa557833adfe14b0d056fff51211a0a1959c591"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2aceddfdb79578d359d8320eb3bab1f04511e459813a1b28e6767a2397e7b39f"
    sha256 cellar: :any,                 arm64_sequoia: "3d7a5f633260a999fcab1857900c37aec93373689b9869e8484b56187fed0ef7"
    sha256 cellar: :any,                 arm64_sonoma:  "1e822c38dad4670a97ffd0456ded75deab670b99682c2c0a010c617844983ac8"
    sha256 cellar: :any,                 sonoma:        "adde4676146e2264f613be3bc430b107ab6b5c2e73b0adcea03656a75e6f5844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fa4dacc7b0986a30b77f0dc46969f7fc9b728ca5892d1601f4619c6e5ff5716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b6e962a229393ad00ce81d9847c2a5b125d6d5a6c3d49dda39afecbffa48e8"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https://rubygems.org/gems/cucumber/versions/10.0.0/dependencies

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
    url "https://rubygems.org/gems/cucumber-messages-27.2.0.gem"
    sha256 "46e2a1454620db3d0811ad990b9a96cd47bfdb5e2ad4f2ae0b41822332979fff"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-21.15.1.gem"
    sha256 "a08d7c30c357bfd4ea746312ed36e75dab5ba069e5ebc364ecfd5508540920e0"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.3.0.gem"
    sha256 "e116f692049da02a180f7b1d49859e828eb3a70d01e2efd8f78fb675738554f5"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-18.0.1.gem"
    sha256 "8398a0bf636af33ff3b61e459a309295eb02745b9e21bd7af0eaaa2a1e6be3e5"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-6.1.2.gem"
    sha256 "f790e4e820b80d453e83c6a462ed6de36b9477b046543322f646c1e8c275916d"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-32.2.0.gem"
    sha256 "a33699d3be9c7fe1b6d4a26c1aa18150f274a90c871a6bc1811d5795a52e4ad6"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-15.2.1.gem"
    sha256 "636a329f877c7ba478b5d9090f810c1b21796f9b601fa33532133ad1910b8588"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-10.0.1.gem"
    sha256 "bb6e3fcec85c981dff4561997e8675a7123eead5fe9e587d2ad7568adbe18631"
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
