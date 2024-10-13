class HasteClient < Formula
  desc "CLI client for haste-server"
  homepage "https://hastebin.com/"
  url "https://github.com/toptal/haste-client/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "9f7e943be47408ba0b9765328794e7b87bdb2a785f1e9edb5d541d67b4a75d31"
  license "MIT"
  revision 1
  head "https://github.com/toptal/haste-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "748d53b8e3a94df95119e4881d97966bde1e0ba7aed5f85088b8009490a65c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19c113dd6fe207816a9c0dc7b3d16c8242d3302b2c0a0d16182508d3c50b69b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c113dd6fe207816a9c0dc7b3d16c8242d3302b2c0a0d16182508d3c50b69b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c113dd6fe207816a9c0dc7b3d16c8242d3302b2c0a0d16182508d3c50b69b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "19c113dd6fe207816a9c0dc7b3d16c8242d3302b2c0a0d16182508d3c50b69b0"
    sha256 cellar: :any_skip_relocation, ventura:        "19c113dd6fe207816a9c0dc7b3d16c8242d3302b2c0a0d16182508d3c50b69b0"
    sha256 cellar: :any_skip_relocation, monterey:       "19c113dd6fe207816a9c0dc7b3d16c8242d3302b2c0a0d16182508d3c50b69b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad7b1ac323cd891c96e1b3e83192519c83761f248d8591b7eae25bf5813d939"
  end

  uses_from_macos "ruby", since: :high_sierra

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.17.6.gem"
    sha256 "a572118695fce2937e3a8bed33498ac0c25a263cdb570ea5cd2e41b36c821c34"
  end

  resource "json" do
    on_system :linux, macos: :sierra_or_older do
      url "https://rubygems.org/gems/json-2.6.3.gem"
      sha256 "86aaea16adf346a2b22743d88f8dcceeb1038843989ab93cda44b5176c845459"
    end
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.3.0.gem"
    sha256 "3dcdd74a767302559fcf91a63b568ee00770494ce24195167b1c147ab3f6fe51"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
             "--install-dir", libexec
    end
    system "gem", "build", "haste.gemspec"
    system "gem", "install", "--ignore-dependencies", "haste-#{version}.gem"
    bin.install libexec/"bin/haste"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    test_file = testpath/"dummy_file"
    touch test_file
    output = shell_output("#{bin}/haste #{test_file} 2>&1", 1)
    assert_match "Unauthorized request: missing access token", output
  end
end
