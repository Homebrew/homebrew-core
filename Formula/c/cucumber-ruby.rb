class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v9.0.2.tar.gz"
  sha256 "2e65f68e0d1d9bbcf58dc528873c23a6cdbd077b66b406de456879d00e357388"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8f8f13f0d1f129304becaaa05c225edcadc19af08ead95d52b56e730a375f8d"
    sha256 cellar: :any,                 arm64_ventura:  "89895c6a4aa25ddca79c64bb1337702097aac2a9ea3b84df417354f5e6bf0792"
    sha256 cellar: :any,                 arm64_monterey: "6cd8dc6a74b2b73dcf50b4e746b94ee9b83b1eeeefe2bcb961940f93ee69cc30"
    sha256 cellar: :any,                 arm64_big_sur:  "2c8ac5748d9ae3957ce8ac1a51449d336212a36c4aef69cccec67d37762ff070"
    sha256 cellar: :any,                 sonoma:         "f43aa924272415c2fef5573756410e4380486e8b8bf83557a27e9bf2a484b49f"
    sha256 cellar: :any,                 ventura:        "9bdbabe46b36e5487e6e37bd39f1b097ecac3ec407b3e1bc1bfe27364a30f73f"
    sha256 cellar: :any,                 monterey:       "fb0c14505012de5b22ccf129b974fbf9a288f21602eedc5be8bb1bc54b8a74fc"
    sha256 cellar: :any,                 big_sur:        "5660abb051e16cc797fc404c03f4237cd143cbbf8029dc7abc34a98e7183e596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cde07b55ea51d1299e8e5601c241ba14c5b5cefcacd3e201eed2d631b1a9f0d3"
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
