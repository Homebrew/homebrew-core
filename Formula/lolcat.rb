class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag => "v99.9.11",
      :revision => "3c870f31462dd1381adb0f4dee28997903f1ecdb"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5eb4fb6071bf4cfea6e06a35a38c7f57d8a25e46ce3905257f4556de0cd7788" => :mojave
    sha256 "46bbfae94cf58c749248b53bbc744230c716d8c863701c277f43db5d159c155b" => :high_sierra
    sha256 "ae227d19279381bb06454be4ab732955f0c98aefe4ec5096af51f89afefb22e2" => :sierra
    sha256 "720bcfcc342a16b3c7df9b5a558561d42d09f268f9708fac4f7f24af9fec81df" => :el_capitan
  end

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
