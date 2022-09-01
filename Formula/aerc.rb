class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.12.0.tar.gz"
  sha256 "402b48367b87338188036e713b3a421e228199accfa5fdb551f5efa21edb23be"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "1d4384f961c29d606a4508361c5132691fcfd8493a5c89e8f8b93fc406b9c163"
    sha256 arm64_big_sur:  "f7e4288c063616ae957cab943fb6b13e64237b31600ad2867ec84d2ca190e224"
    sha256 monterey:       "6299e452331bac92e32a2eea4e63dbe1788abe213ae2e31e0821ee4dc1e7e02e"
    sha256 big_sur:        "95a3edc7977357183c616859da22055a6f7bf6c98689a24e536c8a03f5b02fa1"
    sha256 catalina:       "a26a9ceac3370d8cd803e91d3bca4dce90f0eafeebc416bd6b22379b3a1ec2d0"
    sha256 x86_64_linux:   "cc0267dc875a601dd2abc4332fbeb91a2147cfaecc9fde1b463067da575c10e5"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
