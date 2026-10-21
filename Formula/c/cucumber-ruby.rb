class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "d1e1e3a4d6bebad2403c53982c9890dc0a0b8a31ef3f44b1b4dab32aa7414adf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae29616fd792c77ae7bd88f8ed51ef1abf420532803ec18f2c1775d7acd5d186"
    sha256 cellar: :any, arm64_tahoe:       "f3cbeff4c0e2afd59957aae20d1e15fc3b28efb004bab7a9f6f38fde47674483"
    sha256 cellar: :any, arm64_sequoia:     "73a085b94f7461f787ba4954d5a8ea60514cd679b9ad6daa68c0674049209bc1"
    sha256 cellar: :any, arm64_linux:       "12b1c7368701470dd9f3b6a34ca25c3ac202f7220dee41a495ff96dacadf7cf7"
    sha256 cellar: :any, x86_64_linux:      "b407b4bcb10e7baa28956ae1240c87a037f56fcd2b45c575e00513b930a0cc09"
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
    url "https://rubygems.org/gems/multi_test-2.0.0.gem"
    sha256 "5fe1bf72a3b6f65ebeb0ee5c62c6fbd4cf4e180f06e7213f02ac60847ca094e7"
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
    url "https://rubygems.org/gems/diff-lcs-2.0.0.gem"
    sha256 "708a5d52ec2945b50f8f53a181174aa1ef2c496edf81c05957fe956dabb363d5"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-34.2.1.gem"
    sha256 "1de715dfeaa237939b8ab008987d3fbf3118ba32a86d844fd1503396ecc5bf7e"
  end

  resource "cucumber-query" do
    url "https://rubygems.org/gems/cucumber-query-16.1.1.gem"
    sha256 "96f75ee07c892d21046ac699fb3879abab0686991af1a10a6f73ef0565b7134f"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-24.2.0.gem"
    sha256 "6edc50730e459f9bfea0b0dadfaf4f4066d7083094382ac0d703926414c9cce0"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-4.0.1.gem"
    sha256 "8b07d3d065a9f921c80ceaea7c9d4ae596697295b584c296fe599dd0ad01c4a7"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-20.1.0.gem"
    sha256 "6cc4b5880ba1c3991292579d0451af0f44814f5a1a13d7823317a09705eb15d4"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-11.0.1.gem"
    sha256 "ead62a1c6bb613de1f5469975a9dd11ba2ced7322a6c8837cdde9db33dcbeac5"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-42.0.1.gem"
    sha256 "427efa1996770fd91a6e860e3f2e8b644108682256f4189db494fe85f4595e2f"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-20.0.0.gem"
    sha256 "15034c5f268e5311342d59679fb6310584db7e06e1c7a922c9138cd028dae292"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-13.0.0.gem"
    sha256 "f1c110943e07f72124b43c50c98d96016a77141a4bd45ebee0b8c877d8c264fb"
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
