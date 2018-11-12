class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://github.com/NARKOZ/gitlab"
  url "https://github.com/NARKOZ/gitlab/archive/v4.6.1.tar.gz"
  sha256 "443be89075e5fac2ec0a1b0b92618995e8fc49518fc06022c7c6116769cdf408"

  bottle do
    cellar :any_skip_relocation
    sha256 "86bb4655c199e0ef30357fea12f55905e8cb4551e26d7aacb6ff6cee2736ca18" => :mojave
    sha256 "88d9196f2a246869b85b52646bab110bbd58840ecb1c9a82425e28aa828e125c" => :high_sierra
    sha256 "e3ede5194dc45c86b0a5575d645c556bdfd55cab3064a4b768052e4a7f76a8b3" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.16.2.gem"
    sha256 "fc67e5ba443b5ca822c2babccd3c6ed8bcc75fb67432b99652cb95972d204cff"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-1.8.0.gem"
    sha256 "13371f069af18e9baa4e44d404a4ada9301899ce0530c237ac1a96c19f652294"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.6.0.gem"
    sha256 "d24393cf958adb226db884b976b007914a89c53ad88718e25679d7008823ad52"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-1.4.0.gem"
    sha256 "a72802fd6345c0da220e8088b27f1800924b74d222621a06477757769b5e8000"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "gitlab.gemspec"
    system "gem", "install", "--ignore-dependencies", "gitlab-#{version}.gem"
    bin.install "exe/gitlab"
    bin.env_script_all_files(libexec/"exe", :GEM_HOME => ENV["GEM_HOME"])
    libexec.install Dir["*"]
  end

  test do
    ENV["GITLAB_API_ENDPOINT"] = "https://example.com/"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}/gitlab user 2>&1", 1)
    assert_match "The response is not a valid JSON", output
  end
end
