class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.19.0.tar.gz"
  sha256 "caf830959cf689db257ffb64893fd78f1a362a22fe774dd561340fc552d599eb"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_sequoia: "3019a32175f69b10737575fab2111b94bf37a33c6a7f19e1b31036901d97647b"
    sha256 arm64_sonoma:  "6bff771f6ebd64c3c2ac82ca8f1fb31ee9fff2bbd098e408c4796c3e58b0722e"
    sha256 arm64_ventura: "228205cc8543245c760488bc1851c1677553d26885145e13d298d40bfc2b690c"
    sha256 sonoma:        "5fedb67f191a260144fe12e5e2d84bbc0c3e12fc92119d7f1574c640054c9157"
    sha256 ventura:       "9cf9f262b4a49464810699433478d7c402648804e50206e9fc58daefb7252b71"
    sha256 x86_64_linux:  "28d6ccdac394d622e6da1d79a2b71034ddb32e466d89a65e53c7da3b10d9c827"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}", "VERSION=#{version}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"aerc", "-v"
  end
end
