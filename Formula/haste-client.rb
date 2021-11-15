class HasteClient < Formula
  desc "CLI client for haste-server"
  homepage "https://hastebin.com/"
  license "MIT"
  revision 5
  head "https://github.com/seejohnrun/haste-client.git"

  stable do
    url "https://github.com/seejohnrun/haste-client/archive/v0.2.3.tar.gz"
    sha256 "becbc13c964bb88841a440db4daff8e535e49cc03df7e1eddf16f95e2696cbaf"

    # Remove for > 0.2.3
    # Upstream commit from 19 Jul 2017 "Bump version to 0.2.3"
    patch do
      url "https://github.com/seejohnrun/haste-client/commit/1037d89.patch?full_index=1"
      sha256 "1e9c47f35c65f253fd762c673b7677921b333c02d2c4e4ae5f182fcd6a5747c6"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46460dfe45de7b60b0d9c164f605983e912a42e6bb9278b7e278c1774a041b78"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc90f925bb8d3c217849d04d57ba540cfd1859a555ae78fb89a3d500c61c5e4a"
    sha256 cellar: :any_skip_relocation, catalina:      "d7b5efc8934cbfb2534db7db7b8418142472f980b8f4165c317ab51cc4f14824"
    sha256 cellar: :any_skip_relocation, mojave:        "c38551ce841f7a3cd825e1ae20b774836aba13fe6e129c1539eadde9b9e64a02"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a97b7aaf38ec730bffa45ffc073ccf4921b4e5714069a21bf63e682a9d21527e"
    sha256 cellar: :any_skip_relocation, sierra:        "746af59be7c010e6e13b67d1f98766c0237061eabca601e5f0cad935e1c648bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675af7af84034776b319fa54375925a68641973c22b22792e5cb4136f3500051"
    sha256 cellar: :any_skip_relocation, all:           "7ec8f638454dcbf5cdfe7b7e5c3cdbeb0fc6b1de76158f53f32751cb30a1c3a6"
  end

  depends_on "ruby" if MacOS.version <= :sierra

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.17.4.gem"
    sha256 "11677b5b261fbbfd4d959f702078d81c0bb66006c00ab2f329f32784778e4d9c"
  end

  if MacOS.version <= :sierra
    resource "json" do
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
