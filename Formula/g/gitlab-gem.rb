class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://narkoz.github.io/gitlab/"
  url "https://github.com/NARKOZ/gitlab/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "c08305b376275be73b6da01c14d3e004d49860925770e8e2f760afc3abedd629"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "36c12c66b5d5631481cf0116c72e00d2c2cc92005e52dd7b98171ba9f958adba"
    sha256 cellar: :any,                 arm64_sonoma:   "febf8cba6b5ae71c41b70021c74e77a73c8bd847f802cdbdae2e566bf77b7543"
    sha256 cellar: :any,                 arm64_ventura:  "931cefa46d0818baa052c7e7a5917ed19d326fb86102e992a96a4a7ae93f9b2a"
    sha256 cellar: :any,                 arm64_monterey: "4ccf47ef97c42469e4cb87bcf7d503272be1094a28b6bdff085fbe9c4cc9e7ab"
    sha256 cellar: :any,                 sonoma:         "15a26b3093df8a0515358081e6f8094266cac0a9c4b08ef602d2d7f65d686e1a"
    sha256 cellar: :any,                 ventura:        "b4a8f2e1308a8f33fac73aaf6b8beb9990e81db11f636bc065e3f5366a0a4918"
    sha256 cellar: :any,                 monterey:       "9c4df067b814a648b95734bd9cc1daec717d96fff81098436cd97d924198da39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c3f066efa9e4efd26169ee94ecae0cdd4059dd7593795210e387e636e44aff"
  end

  depends_on "ruby"

  # list with `gem install --explain httparty terminal-table`

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.8.gem"
    sha256 "a89467ed5a44f8ae01824af49cbc575871fa078332e8f77ea425725c1ffe27be"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.7.1.gem"
    sha256 "4fce100c68af588ff91b8ba90a0bb3f0466f06c909f21a32f4962059140ba61b"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "csv" do
    url "https://rubygems.org/gems/csv-3.3.0.gem"
    sha256 "0bbd1defdc31134abefed027a639b3723c2753862150f4c3ee61cab71b20d67d"
  end

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.22.0.gem"
    sha256 "78652a5c9471cf0093d3b2083c2295c9c8f12b44c65112f1846af2b71430fa6c"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-2.5.0.gem"
    sha256 "7e7681dcade1add70cb9fda20dd77f300b8587c81ebbd165d14fd93144ff0ab4"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-3.0.2.gem"
    sha256 "f951b6af5f3e00203fb290a669e0a85c5dd5b051b3b023392ccfd67ba5abae91"
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
