class HasteClient < Formula
  desc "CLI client for haste-server"
  homepage "https://hastebin.com/"
  head "https://github.com/seejohnrun/haste-client.git"
  revision 1

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
    cellar :any_skip_relocation
    sha256 "b7b70e6a090bc14e4ec5bb634f7b30778d92a555e421181840139a32a8a7e056" => :high_sierra
    sha256 "821e18033eebddc3a0ef8ae93ff675aa1407addaff6b228639a17351acd27da8" => :sierra
    sha256 "3189295fb6df33a604a3f1bb8a556853fcdfc7a66bcf7183f3bc6a95305155bf" => :el_capitan
    sha256 "6feb00bfc1cf9387929d554acf24c92df081584396a072c9cfb265cbbe8b0e54" => :yosemite
  end

  depends_on :ruby => "2.3"

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.12.2.gem"
    sha256 "6299046a78613ce330b67060e648a132ba7cca4f0ea769bc1d2bbcb22a23ec94"
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.0.0.gem"
    sha256 "3dc44e50d3df3d42da2b86272c568fd7b75c928d8af3cc5f9834e2e5d9586026"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
             "--install-dir", libexec
    end
    system "gem", "build", "haste.gemspec"
    system "gem", "install", "--ignore-dependencies", "haste-#{version}.gem"
    bin.install libexec/"bin/haste"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    output = pipe_output("#{bin}/haste", "testing", 0)
    assert_match(%r{^https://hastebin\.com/.+}, output)
  end
end
