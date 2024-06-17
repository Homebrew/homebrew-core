class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://narkoz.github.io/gitlab/"
  url "https://github.com/NARKOZ/gitlab/archive/refs/tags/v4.20.1.tar.gz"
  sha256 "2505a4e4b572be808c613a69903d3a91bc4c28d6db3f632679d42d3f395d957a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4b34ccc6d5ce5675a7dcbabc284a2cb9c78ae915b1bc72e274e0f703f27fc02"
    sha256 cellar: :any,                 arm64_ventura:  "6e184ac89b243b7066782698fa335239b48b3bfe9731dea1894e09558282670f"
    sha256 cellar: :any,                 arm64_monterey: "bd09da68a956d0da8dcb3b7815503091fbf4d52a18ed3a85745a52ccef57bbab"
    sha256 cellar: :any,                 sonoma:         "6081be99988d24e027fa18cc8d7620b7cdfc1ad57e90768d2e43220d344a27dd"
    sha256 cellar: :any,                 ventura:        "1d310c144551add97d0a6042a4742fcbb4b870e7b31e5423e7d3484a8b584e92"
    sha256 cellar: :any,                 monterey:       "8ba80fbf9ee3f1eb352b415679de063dc291af003f191b0d99fce43edb342ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f05028ad35fce6b26c53901a3d46bede96447f968fb756186cdf592274b50f0"
  end

  depends_on "ruby"

  # list with `gem install --explain httparty terminal-table`

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.5.gem"
    sha256 "534faee5ae3b4a0a6369fe56cd944e907bf862a9209544a9e55f550592c22fac"
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
    url "https://rubygems.org/gems/csv-3.2.8.gem"
    sha256 "2f5e11e8897040b97baf2abfe8fa265b314efeb8a9b7f756db9ebcf79e7db9fe"
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
    assert_match "404 - Not Found", output

    assert_match version.to_s, shell_output("#{bin}/gitlab --version")
  end
end
