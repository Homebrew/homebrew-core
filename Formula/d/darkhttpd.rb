class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://github.com/emikulic/darkhttpd/archive/refs/tags/v1.16.tar.gz"
  sha256 "ab97ea3404654af765f78282aa09cfe4226cb007d2fcc59fe1a475ba0fef1981"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8acef684427142565d90c96db616fa7bcf1a28bf0d4fca71aacea8fc8cab2996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e57b5d8505d7a4073aa5d3bc46d06482332241cc7e28bfa2ba6a1257100ceec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0754b61bb91a3ffc1ac81c6b9caa11d3f165025abc78ea02faf114c8680ed236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3eba7b21645b53ce4129a5225d757046ed601d2ca937686aebd11b80bd381be"
    sha256 cellar: :any_skip_relocation, sonoma:         "cda44bc98470b2f53b0485af56ee360630c05ad1a8a1a05bca5c9ca0ea982e47"
    sha256 cellar: :any_skip_relocation, ventura:        "9f424d6282015f95909fef901b9519f6c4d6ac8b42af1cd08cdd8b889b2b7ef5"
    sha256 cellar: :any_skip_relocation, monterey:       "cd10faefba5c4988de8011263451f734e6e05a222839b6cb3218764643da4835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8cd915b3d815dbae18a6a91f7f6027569d5d020101c19fde5d035d5d433a74"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system bin/"darkhttpd", "--help"
  end
end
