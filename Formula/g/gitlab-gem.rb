class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://narkoz.github.io/gitlab/"
  url "https://github.com/NARKOZ/gitlab/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "dfafb3b2ddaaaa94b78da5e2cb7515199160def567cb936606a5dae9e270a9b7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87d2c74b681accd514f34cbc225b5033659d7016b7a90394bb87783dd60d57be"
    sha256 cellar: :any,                 arm64_sequoia: "2db88a26ef2ad02dce9460fd0f0ec1d1a27df0f7da41f3bc1d8aee1e0f9f0bcd"
    sha256 cellar: :any,                 arm64_sonoma:  "c87c1a72f1d4770fedf06887007f64436a6876439726394dad089cc35bdd4901"
    sha256 cellar: :any,                 arm64_ventura: "955384293995236ffa6baef6c2b48a0c4d172bf35ea7276e52bdd20db9e54c99"
    sha256 cellar: :any,                 sonoma:        "bca39b4ac6f7a6f39a1eb09518121bc830adcdcb11b044c2bb030e23811fef8b"
    sha256 cellar: :any,                 ventura:       "5124a2de109b13f4e6f840fe8a0b5b659ee8b909aec301f39e0c376473e9fb9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b40a309432dd207f09baf705b58872833d21552b1ca00216be8a9ebfe7d28e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ed9be89b1924b80695a196bbb9b14e05521cff6fa576c1993cf5c74dcc9e453"
  end

  depends_on "ruby"

  # list with `gem install --explain httparty terminal-table`

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.7.2.gem"
    sha256 "307a96dc48613badb7b2fc174fd4e62d7c7b619bc36ea33bfd0c49f64f5787ce"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "csv" do
    url "https://rubygems.org/gems/csv-3.3.2.gem"
    sha256 "6ff0c135e65e485d1864dde6c1703b60d34cc9e19bed8452834a0b28a519bd4e"
  end

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.23.1.gem"
    sha256 "3ac1dd62f2010f6ece551716f5ceec2b2012011d89f1751917ab7f724e966b55"
  end

  resource "unicode-emoji" do
    url "https://rubygems.org/gems/unicode-emoji-4.0.4.gem"
    sha256 "2c2c4ef7f353e5809497126285a50b23056cc6e61b64433764a35eff6c36532a"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-3.1.4.gem"
    sha256 "8caf2af1c0f2f07ec89ef9e18c7d88c2790e217c482bfc78aaa65eadd5415ac1"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-4.0.0.gem"
    sha256 "f504793203f8251b2ea7c7068333053f0beeea26093ec9962e62ea79f94301d2"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "gitlab.gemspec"
    system "gem", "install", "--ignore-dependencies", "gitlab-#{version}.gem"
    (bin/"gitlab").write_env_script libexec/"bin/gitlab", GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    ENV["GITLAB_API_ENDPOINT"] = "https://example.com/"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}/gitlab user 2>&1", 1)
    assert_match "Server responded with code 404, message", output

    assert_match version.to_s, shell_output("#{bin}/gitlab --version")
  end
end
