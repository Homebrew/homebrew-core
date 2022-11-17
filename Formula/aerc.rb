class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.13.0.tar.gz"
  sha256 "d8717ab2c259699b6e818a8f8db1e24033a2e09142e2e9b873fa5de6ee660bd8"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_ventura:  "d14161489279adff83ab696d008290069051018c40e722c1815cc48df8a8b974"
    sha256 arm64_monterey: "f660d7ceb8bfbf36ce223d58681262039fe025fe8a80ec1ff7ad0dce12167a1d"
    sha256 arm64_big_sur:  "75e3075aed7579774d740ced173c261ed4eb16e543b3cfd7876e7e48d280d983"
    sha256 ventura:        "f26343e0a1fac3c7a421e4848f2b7cbe5a9fc8954f69a097752d6d5d31fa146e"
    sha256 monterey:       "60529eb9bce505a6c3317b645100f646cc77b8ab3f2e353821190954f1c79d9b"
    sha256 big_sur:        "0b6a2c62f75a94888425e61793f4b7a16de9f85825d0fc2395a55798a26c4a43"
    sha256 catalina:       "cf152e4053bfb8945634112d510ee38fdae83a3afe168226f9c08fe3bc6ba7ac"
    sha256 x86_64_linux:   "c82fd881c987a7ee7d168b99d44713946aacf9cd3856671f17aee0748f216aa7"
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
