class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://github.com/emikulic/darkhttpd/archive/v1.14.tar.gz"
  sha256 "e063de9efa5635260c8def00a4d41ec6145226a492d53fa1dac436967670d195"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "921aa3ea1fcbef858eaa7f27edb3c155939a3532257795d23ec09baf4c5daff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20cc4363df790f1ab094acca40a37b501b2ade963f59b4776963d8fbf499ae07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e60532b603188fe20c282e1ba50432536c2bd9f1c8726dc6854ee621cdc424c8"
    sha256 cellar: :any_skip_relocation, ventura:        "f677aec850c401364a377b9bf02792d03eca57bb2c9557b509e537cfd3b2cd70"
    sha256 cellar: :any_skip_relocation, monterey:       "23b5e2cb7ab606293771b35c88a9c4e7a8563df7f095a80662ff1f57c48f65c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad64ddeea1173ec2ef0f7ba20f54192227f818afc3e94ccac3ab535497d29263"
    sha256 cellar: :any_skip_relocation, catalina:       "8e32c73f5f737c112ea7b631a16238bb46b7bd8fc13f75ea8473a96d479f93d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fae114eb7efde0eef9075a08bd5f14d6fca5a5eb891e6b4b84a8bbdd00c36cd"
  end

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
