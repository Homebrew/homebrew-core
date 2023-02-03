class HasteClient < Formula
  desc "CLI client for haste-server"
  homepage "https://hastebin.com/"
  license "MIT"
  head "https://github.com/toptal/haste-client.git", branch: "master"

  stable do
    url "https://github.com/toptal/haste-client/archive/v0.3.0.tar.gz"
    sha256 "9f7e943be47408ba0b9765328794e7b87bdb2a785f1e9edb5d541d67b4a75d31"

    # Remove for > 0.2.3
    # Upstream commit from 19 Jul 2017 "Bump version to 0.2.3"
    patch do
      url "https://github.com/toptal/haste-client/commit/1037d89.patch?full_index=1"
      sha256 "1e9c47f35c65f253fd762c673b7677921b333c02d2c4e4ae5f182fcd6a5747c6"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc801c71f126d37c41d0a482dbc45764fd5ed30c7d1c89e549274cf37f984017"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc801c71f126d37c41d0a482dbc45764fd5ed30c7d1c89e549274cf37f984017"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d4950a8e14856b464bdd84e2622979a0f5fb80a44566ebf172286b714887bdd"
    sha256 cellar: :any_skip_relocation, ventura:        "dc801c71f126d37c41d0a482dbc45764fd5ed30c7d1c89e549274cf37f984017"
    sha256 cellar: :any_skip_relocation, monterey:       "dc801c71f126d37c41d0a482dbc45764fd5ed30c7d1c89e549274cf37f984017"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc801c71f126d37c41d0a482dbc45764fd5ed30c7d1c89e549274cf37f984017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1863cf6bdf7665c478d3c440a7841afbfa1d50f3a25841eac3e50559909d6fd1"
  end

  uses_from_macos "ruby", since: :high_sierra

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.17.4.gem"
    sha256 "11677b5b261fbbfd4d959f702078d81c0bb66006c00ab2f329f32784778e4d9c"
  end

  resource "json" do
    on_system :linux, macos: :sierra_or_older do
      url "https://rubygems.org/gems/json-2.5.1.gem"
      sha256 "918d8c41dacb7cfdbe0c7bbd6014a5372f0cf1c454ca150e9f4010fe80cc3153"
    end
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.1.1.gem"
    sha256 "d2dd7aa957650e0d99e0513cd388401b069f09528441b87d884609c8e94ffcfd"
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
    output = pipe_output("#{bin}/haste", "testing", 0)
    assert_match(%r{^https://hastebin\.com/.+}, output)
  end
end
