class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://narkoz.github.io/gitlab/"
  url "https://github.com/NARKOZ/gitlab/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "fdb4cab8f09258b9b8a70b3cddd618dc19a10303124a9176dd7ca5ed70f98ce4"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05f1b0962f1cdc0ba8325a1cb2161aad2fb2c2d93c144c1efd8aa861b7faac12"
    sha256 cellar: :any,                 arm64_sonoma:  "040dfa582c413b0c51cedffc28d3edc5d5482b4c3584e1553fb31fbb9c76ad9e"
    sha256 cellar: :any,                 arm64_ventura: "46f87e54a723b07f5813a32f9d5391c471a6384929e4a1880cf27a864d55543d"
    sha256 cellar: :any,                 sonoma:        "7d01617823ef02f76e5ef3ca2f31fbdc07c78c0ecb93fa89b2cad893971851e3"
    sha256 cellar: :any,                 ventura:       "c1b354fab666cfffd496156c33b9a8c0bafb5ed371bcf9b1ffdd6ddab30e015d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f059f0148490b7eaffb7a619c8c7cb146b511defea2b4c9d146c68b68e2da7e4"
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
