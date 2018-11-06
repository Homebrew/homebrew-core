class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://github.com/NARKOZ/gitlab"
  url "https://github.com/NARKOZ/gitlab/archive/v4.6.1.tar.gz"
  sha256 "443be89075e5fac2ec0a1b0b92618995e8fc49518fc06022c7c6116769cdf408"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eca674d3f0c8c9bd87bc329ca342d0c94a5fcb42d1ab9ace15713a9b313a9d2" => :mojave
    sha256 "73b3d86b32fe46c9e1e343175ea27ddf475a58cecf46a7a9801f82b9dd65114a" => :high_sierra
    sha256 "fefa2c48ce82227f1b6f6754fa40a3cbbf7d8429eb469637a3f63697701b77a1" => :sierra
    sha256 "967488b9481bf99a3f60353a80f292236ad00984b1f5a10ae52e0c4602bbad77" => :el_capitan
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
