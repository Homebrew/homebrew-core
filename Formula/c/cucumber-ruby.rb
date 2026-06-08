class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v11.1.0.tar.gz"
  sha256 "ea8a759fcf703a15734a1f83bfe796fa62eb3a71c2df14283b482e670ba3de58"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b86b5e7d27f4245d98b504e107a213256244dafdb3f18d34070d16d70dc11903"
    sha256 cellar: :any, arm64_sequoia: "9863783522a6bbdc20288f4931c7e76779a9699554465738123ee38af8739827"
    sha256 cellar: :any, arm64_sonoma:  "69879b23eaa5d69c54f6003edfda642e17496a676c63c0f3323fd5d09c0a69ee"
    sha256 cellar: :any, sonoma:        "3a9b7ca65988bb2ba278832b38355b8d09b9017a50572570011bf8ecff289a64"
    sha256 cellar: :any, arm64_linux:   "4698ffa4a23d2351d38f92e3b83292895405dbe35181cc55980dbdeeb65fbf67"
    sha256 cellar: :any, x86_64_linux:  "03717e084d2237dab082ed9c9487d2bf987b1cefd5b98534f416f6fcb3eb8554"
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
    url "https://rubygems.org/gems/bigdecimal-4.1.2.gem"
    sha256 "53d217666027eab4280346fba98e7d5b66baaae1b9c3c1c0ffe89d48188a3fbd"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-19.0.1.gem"
    sha256 "648ec09045190d818fb797af46e1648148599fd67a086a34a7f0e647d9e36c8c"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-8.1.0.gem"
    sha256 "9bd8c4b6654f8e5bf2a9c99329b6f32136a75e50cd39d4cfb3927d0fa9f52e21"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-39.1.0.gem"
    sha256 "aed12a0c955d8563d80a012633c1a72075525f4d64d4cc983001df2181b379ed"
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
