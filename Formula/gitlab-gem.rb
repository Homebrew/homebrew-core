class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://github.com/NARKOZ/gitlab"
  url "https://github.com/NARKOZ/gitlab/archive/v4.17.0.tar.gz"
  sha256 "53d2658073e1ffdca0b67b971b4280542b4d831bfb9baf06836e8063cfadb801"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f1b74846038c11a6b60b05e7d43f24e0c13ad57fca5477959d4353e50f43736"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c4a0fb41401e668a957c23d934896ead423f78ee65099b451c34a5b5243224f"
    sha256 cellar: :any_skip_relocation, catalina:      "9fb83bdf349a57916534fd40a2e38db4a893b713207abe572117e21d21e9df7b"
    sha256 cellar: :any_skip_relocation, mojave:        "2bd6150b2c26c4b746ffc8c2f43c05b311ec33c08f88a82946d08e63f6dea9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46229291b4e82400ed94407d29c04390edba62b6b1e007eedbdefe9b7ba1136"
    sha256 cellar: :any_skip_relocation, all:           "98d7d195f9056f824111633f08ba7c49c19e907087de006174c81a6123c9bf04"
  end

  uses_from_macos "ruby", since: :catalina

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.18.1.gem"
    sha256 "878fe8038e344b219dbba9e20c442914a2be251d2f4a20bcdeb31f25dcb2f79d"
  end

  resource "mime-types" do
    url "https://rubygems.org/gems/mime-types-3.3.1.gem"
    sha256 "708f737e28ceef48b9a1bc041aa9eec46fa36eb36acb95e6b64a9889131541fe"
  end

  resource "mime-types-data" do
    url "https://rubygems.org/gems/mime-types-data-3.2020.0512.gem"
    sha256 "a31c1705fec7fc775749742c52964a0e012968b43939e141a74f43ffecd6e5fc"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.6.0.gem"
    sha256 "d24393cf958adb226db884b976b007914a89c53ad88718e25679d7008823ad52"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-1.8.0.gem"
    sha256 "13371f069af18e9baa4e44d404a4ada9301899ce0530c237ac1a96c19f652294"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-1.7.0.gem"
    sha256 "cad681071867a4cf52613412e379e39e85ac72b1d236677a2001187d448b231a"
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
    assert_match "Server responded with code 404", output
  end
end
