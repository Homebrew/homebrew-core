class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "7c6adb2d3124842c5dd78e27f0e620a5d780bee152144c8eccdc2b57924941ad"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7bf9179232a51b9aef4b8996562877eae7b7df99c7e6336c0963200494481751"
    sha256 cellar: :any,                 arm64_sequoia: "bf5055da839e360c7f6d648675ec1d529085fe3f6605c54ec08f254f0c69dd57"
    sha256 cellar: :any,                 arm64_sonoma:  "b1b7e2dcc64552aca2783bb1d7bde33ad53e516f0ad568b69e1412f9b68cb1a8"
    sha256 cellar: :any,                 arm64_ventura: "1413a9372c032ff5522dcfa88a1b8a5387db18c674fd43c101c9e2018bd67486"
    sha256 cellar: :any,                 sonoma:        "479f426269b9a68a68f0db9e1c61767ed7b768189bacf959a64a8ff109715e99"
    sha256 cellar: :any,                 ventura:       "695fdb310b4ea11870cbe3c7b4b5ec8af6b7390781e1f746bebc5e2d74949c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2c8289253b9a8e65a80828aef74cbc95d7d0f9c7059bc53fb8b485e7a1a6f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20699f7174cd7e792f3e3de142f70416f3a49da8c0c4b42cc21ac649955e1565"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi", since: :catalina

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https://rubygems.org/gems/cucumber/versions/10.0.0/dependencies

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.17.2.gem"
    sha256 "297235842e5947cc3036ebe64077584bff583cd7a4e94e9a02fdec399ef46da6"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.3.1.gem"
    sha256 "b7b3eb817a9dd4a2f26a8b616a4f150ab1b79f4682d7538ceb992c8b7346f49c"
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
    url "https://rubygems.org/gems/cucumber-html-formatter-21.14.0.gem"
    sha256 "7fbaeb38c76e982848cf144136544853102ed906b6e54070bba409e505742267"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
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
    url "https://rubygems.org/gems/cucumber-core-15.2.0.gem"
    sha256 "18e45bd05d0fa44342b9f39d89b07a832063922d946c854e87013f94461b72a8"
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
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_path_exists testpath/"features"
  end
end
