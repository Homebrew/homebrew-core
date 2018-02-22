class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://github.com/NARKOZ/gitlab"
  url "https://github.com/NARKOZ/gitlab/archive/v4.3.0.tar.gz"
  sha256 "b2679d0696642f67ba84a4f9df21ad4a7bf1bc814d7f86218b72ebe5e56ff2d0"

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.16.0.gem"
    sha256 "c3e08fac9079fdbe175158782c61f6db6a1918446399560d0bfce1e752b5a5d2"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-1.8.0.gem"
    sha256 "13371f069af18e9baa4e44d404a4ada9301899ce0530c237ac1a96c19f652294"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.5.5.gem"
    sha256 "08936dc294586ee1d178217cce577febe26315d7880e01e4f8e97cf2753b1945"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-1.1.2.gem"
    sha256 "d966add501d3c35fc5ba2cba50d78bf58567fa187e73b4a549de5bc3c6f6d351"
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
    ENV["GITLAB_API_ENDPOINT"] = "http://example.com"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}/gitlab user 2>&1", 1)
    assert_match "The response is not a valid JSON", output
  end
end
