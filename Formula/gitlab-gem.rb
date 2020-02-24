class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://github.com/NARKOZ/gitlab"
  url "https://github.com/NARKOZ/gitlab/archive/v4.11.0.tar.gz"
  sha256 "c709833c28781b995ea141349d7b67735e27e4ae19ccfecf7d0ba27be50f3d4e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9ab14dc657aa6ed5e546fc1669ef43de7877744aff96db2d191d9f02742ad8" => :catalina
    sha256 "3674be8dfcebf52fcf079822ebdcfc1afa9783105edc25571006a5e6169e912d" => :mojave
    sha256 "5ad1f4241fa031436247c4923446f9621a7e4af452d3c2a4c65ba6663416ec89" => :high_sierra
  end

  uses_from_macos "ruby"

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
      r.fetch
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
