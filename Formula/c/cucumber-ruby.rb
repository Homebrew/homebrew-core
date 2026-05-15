class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "c139c3d72a7cd23310cf84c1c9abcf51c232aaa0205564c97ff8c0ab93e3d6b6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03664eff5507e56c1e2f241c2b6ab42756ce58150bd8d15a2f68dce84e5ff6e4"
    sha256 cellar: :any,                 arm64_sequoia: "a7217fc707127efb8426d4b7d12f214d0784fb3b91c464d9cb61ac985ae90701"
    sha256 cellar: :any,                 arm64_sonoma:  "79a943847748bec1e4b67f4b6008f86e7defc6fd069ea83f0e94f4e0cc25d460"
    sha256 cellar: :any,                 sonoma:        "d40e7a61bbb51daa052acbb16c60ca859a5b43218fc20d216ff5b8791a9fcf9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48dfc3be6eb6d55f7a87c3f39d976bbebdb5bcd6f0c1a706ec93840ad6f1793e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9eaef36011a0e4ce470d13bd90a7c2b2832c033ed695d30f08cafc93076fcf"
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
    url "https://rubygems.org/gems/ffi-1.17.4.gem"
    sha256 "bcd1642e06f0d16fc9e09ac6d49c3a7298b9789bcb58127302f934e437d60acf"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.5.1.gem"
    sha256 "784d7e6491b0393c25cbbe5ac38324ac7be9fda083a6094832648af669386d7b"
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
    url "https://rubygems.org/gems/cucumber-messages-32.3.1.gem"
    sha256 "ddc88e4c1cf7afb96c06005b92a4a6f221a2fa435a8b4ca04677d215fd82771c"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-23.1.0.gem"
    sha256 "7789b4a792c876394b9604aeb66aa5cf4c61514473b7e712c76d5eaedcdd8cdf"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-4.0.1.gem"
    sha256 "8b07d3d065a9f921c80ceaea7c9d4ae596697295b584c296fe599dd0ad01c4a7"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-19.0.0.gem"
    sha256 "33208ff204732ac9bed42b46993a0a243054f71ece08579d57e53df6a1c9d93a"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-8.1.0.gem"
    sha256 "9bd8c4b6654f8e5bf2a9c99329b6f32136a75e50cd39d4cfb3927d0fa9f52e21"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-39.0.0.gem"
    sha256 "46f51d87e910f41c3c5cee3b500028ca2b2e7149a413a8280b9a58cee2593e55"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-16.2.0.gem"
    sha256 "592b58a95cf42feef8e5a349f68e363784ba3b6568ffbcf6776e38e136cf970b"
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
