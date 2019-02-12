class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag      => "v99.9.21",
      :revision => "58d5b5ba6d1d3f70aa72b140ee84034aaab91a9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a73327392af6889de24d8726eb4f1946c4dd55b6a9bd1cb7ddcae1c76e93f023" => :mojave
    sha256 "7b54960a6747828d3ad4deb0da56fe16bed72befc56e6d0d27c3cf3a0734bcc1" => :high_sierra
    sha256 "460b4f13561187598ce13996dbd75fc0674ec5d6ff28f38da5999f2176e4041c" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lolcat.gemspec"
    system "gem", "install", "lolcat-#{version}.gem"
    bin.install libexec/"bin/lolcat"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is
      a test
    EOS

    system bin/"lolcat", "test.txt"
  end
end
