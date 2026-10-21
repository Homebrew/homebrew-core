class Licensee < Formula
  desc "Detect under what license a project is distributed"
  homepage "https://licensee.github.io/licensee/"
  # Must be git, because licensee.gemspec uses git ls-files
  url "https://github.com/licensee/licensee.git",
      tag:      "v10.1.0",
      revision: "fb924e7b69b81488092ddbc183afa5ebe45abf1a"
  license "MIT"
  head "https://github.com/licensee/licensee.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "795ab47b71b96b3e0a29d9775aee1ddb786bc468dab747c0cffe91e1f6006e69"
    sha256 cellar: :any, arm64_tahoe:       "bacf988b99ae3158b2ece6936b6f51a64098b08201dd117d860683b0e532e0d6"
    sha256 cellar: :any, arm64_sequoia:     "a21a560dbbb44a499515ba8d9855e76b02b7f564d4bd578e64b965316c284822"
    sha256 cellar: :any, arm64_linux:       "3fb77ed96223ef5ffecb544954bd33d4ceb8a29f2ba540d3262ccdf4cbc966be"
    sha256 cellar: :any, x86_64_linux:      "44b80fe940da793cabc81bd8c0bc2924bc7f9653fce84f702659db569cf04524"
  end

  depends_on "pkgconf" => :build
  depends_on "libgit2"
  depends_on "ruby"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # List with `gem install --explain licensee --platform ruby -v #{version}`
  resource "thor" do
    url "https://rubygems.org/downloads/thor-1.5.0.gem"
    sha256 "e3a9e55fe857e44859ce104a84675ab6e8cd59c650a49106a05f55f136425e73"
  end

  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.8.1.gem"
    sha256 "4a7f6929691dbec8b5209a0b373bc2614882b55fc5d2e447a21aaa691303d62f"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/downloads/mini_portile2-2.8.9.gem"
    sha256 "0cd7c7f824e010c072e33f68bc02d85a00aeb6fce05bb4819c03dfd3c140c289"
  end

  resource "nokogiri" do
    url "https://rubygems.org/downloads/nokogiri-1.19.4.gem"
    sha256 "50c951611c92bca05c51411aef45f1cbc50f2821c4802758c5c6d34696533ab5"
  end

  resource "reverse_markdown" do
    url "https://rubygems.org/downloads/reverse_markdown-3.0.2.gem"
    sha256 "818ebb92ce39dbb1a291690dd1ec9a6d62530d4725296b17e9c8f668f9a5b8af"
  end

  resource "logger" do
    url "https://rubygems.org/downloads/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "json" do
    url "https://rubygems.org/downloads/json-2.18.0.gem"
    sha256 "b10506aee4183f5cf49e0efc48073d7b75843ce3782c68dbeb763351c08fd505"
  end

  resource "uri" do
    url "https://rubygems.org/downloads/uri-1.1.1.gem"
    sha256 "379fa58d27ffb1387eaada68c749d1426738bd0f654d812fcc07e7568f5c57c6"
  end

  resource "net-http" do
    url "https://rubygems.org/downloads/net-http-0.9.1.gem"
    sha256 "25ba0b67c63e89df626ed8fac771d0ad24ad151a858af2cc8e6a716ca4336996"
  end

  resource "faraday-net_http" do
    url "https://rubygems.org/downloads/faraday-net_http-3.4.4.gem"
    sha256 "0e78af151747ed1b00f33e25973b4bc220d7f16c00c39676817c8b12331eb588"
  end

  resource "faraday" do
    url "https://rubygems.org/downloads/faraday-2.14.4.gem"
    sha256 "9bb4408c44621b0dbaaaa39e5dbfc4dbe58cc6751b6eb94d16ae9e1f2f2fab6e"
  end

  resource "public_suffix" do
    url "https://rubygems.org/downloads/public_suffix-7.0.5.gem"
    sha256 "1a8bb08f1bbea19228d3bed6e5ed908d1cb4f7c2726d18bd9cadf60bc676f623"
  end

  resource "addressable" do
    url "https://rubygems.org/downloads/addressable-2.9.0.gem"
    sha256 "7fdf6ac3660f7f4e867a0838be3f6cf722ace541dd97767fa42bc6cfa980c7af"
  end

  resource "sawyer" do
    url "https://rubygems.org/downloads/sawyer-0.9.3.gem"
    sha256 "0d0f19298408047037638639fe62f4794483fb04320269169bd41af2bdcf5e41"
  end

  resource "octokit" do
    url "https://rubygems.org/downloads/octokit-10.0.0.gem"
    sha256 "82e99a539b7637b7e905e6d277bb0c1a4bed56735935cc33db6da7eae49a24e8"
  end

  resource "dotenv" do
    url "https://rubygems.org/downloads/dotenv-3.2.0.gem"
    sha256 "e375b83121ea7ca4ce20f214740076129ab8514cd81378161f11c03853fe619d"
  end

  # Optional, for scanning committed trees and bare Git repositories
  resource "rugged" do
    url "https://rubygems.org/downloads/rugged-1.9.6.gem"
    sha256 "c6e45250e51cdf19f6130d050e280ba8d6af475d4c76580f91377a59fe23d3c7"
  end

  deny_network_access!

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      args += ["--", "--use-system-libraries"] if %w[nokogiri rugged].include?(r.name)
      system "gem", "install", r.cached_download, *args
    end
    # Output name set explicitly as the HEAD gemspec version differs from `version`
    system "gem", "build", "#{name}.gemspec", "-o", "#{name}-#{version}.gem"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensee version").strip

    cp prefix/"LICENSE.md", testpath
    system "git", "init"
    system "git", "add", "LICENSE.md"
    system "git", "commit", "-m", "Initial commit"
    # Only detectable from the commit, which needs rugged
    rm "LICENSE.md"
    assert_match(/License:\s+MIT/, shell_output("#{bin}/licensee detect #{testpath}"))
  end
end
