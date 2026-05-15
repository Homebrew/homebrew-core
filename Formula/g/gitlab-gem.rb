class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://narkoz.github.io/gitlab/"
  url "https://github.com/NARKOZ/gitlab/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "a1a0d2885994d15ef432818bdcaf1421c98a95c364d66284d46be432e115569d"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "28a634a10d64dd6205d560f27a925cf90f44a9dc65df22e4a3459f73a3f2a2a9"
    sha256 cellar: :any,                 arm64_sequoia: "e1a7e8d12754a76599ab213a19a4b493d129a5b789f6a6f0e148c46deee4c893"
    sha256 cellar: :any,                 arm64_sonoma:  "f9e0340a1aee2683d9f00299793417315ca61a41f022e8f0a3efc88fab1cbba6"
    sha256 cellar: :any,                 sonoma:        "9bbddff38c9c1ba7e7c93a2a5ae77193074cd7155bac3f7ec79662656eeece6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e20a0f8c40e295b45801ddb73894a99f30a3bee85b0838444047f15a0aae3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "213d74835f53b03be09a324f70c292a457df7eb83c89d4aec419a37bf428805d"
  end

  depends_on "ruby"

  # List with `gem install --explain gitlab -v #{version}`
  # https://rubygems.org/gems/gitlab/versions/#{version}/dependencies

  resource "unicode-emoji" do
    url "https://rubygems.org/gems/unicode-emoji-4.2.0.gem"
    sha256 "519e69150f75652e40bf736106cfbc8f0f73aa3fb6a65afe62fefa7f80b0f80f"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-3.2.0.gem"
    sha256 "0cdd96b5681a5949cdbc2c55e7b420facae74c4aaf9a9815eee1087cb1853c42"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-4.0.0.gem"
    sha256 "f504793203f8251b2ea7c7068333053f0beeea26093ec9962e62ea79f94301d2"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-4.0.1.gem"
    sha256 "8b07d3d065a9f921c80ceaea7c9d4ae596697295b584c296fe599dd0ad01c4a7"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.8.0.gem"
    sha256 "8d4adcd092f8e354db496109829ffd36969fdc8392cb5fde398ca800d9e6df73"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "csv" do
    url "https://rubygems.org/gems/csv-3.3.5.gem"
    sha256 "6e5134ac3383ef728b7f02725d9872934f523cb40b961479f69cf3afa6c8e73f"
  end

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.23.2.gem"
    sha256 "72d52830ab5862115a3c9a4b16738dd67d9a691ffd796cf86bad8abaa8f1febb"
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
