class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/owasp-noir/noir"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "16d82dfd3e7891cbc60eb5282b8e1086c97a09baf0a4af73ba4263776d7c5b39"
  license "MIT"

  bottle do
    sha256 arm64_sequoia:  "de831b2e2eb096f136a1732de4194781c16ade6ba964a596dd089e62230d324b"
    sha256 arm64_sonoma:   "b7e5a97d3f175cab54cfd3769324a609f9f2f58503bce1e80a506fd9834e5330"
    sha256 arm64_ventura:  "23b8c73886ecf49b0c3dd90120b17650c01dea53be6abe38382690e58dd13abe"
    sha256 arm64_monterey: "a12305a19874fc221ddb315e5c51291abff970f8109d2c0f6524935a2b311e29"
    sha256 sonoma:         "a961806c811709ef492e0a72b430211c7fcdd0eb53d67f0187ea3ebb3b556e0f"
    sha256 ventura:        "c659361f9ec8751ddca8da8abcc4893e9b75baa7c559c725f69222cbe1f24e49"
    sha256 monterey:       "904138d87a29f98a71150b1995da3ca70be66b95aa4a5ba4dcf33b676b3903b1"
    sha256 x86_64_linux:   "b8cf1677ac6ebcaf7c8a6d45027163472c04de27dd7772d6f9c5bcd6caa09f62"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/owasp-noir/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
