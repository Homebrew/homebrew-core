class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag => "v99.9.11",
      :revision => "3c870f31462dd1381adb0f4dee28997903f1ecdb"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ef4486eb2d3247c74d11fbc41e8aa8b8b62839f297a8b0b8b48505dfa7faa36" => :high_sierra
    sha256 "f31fe40b97c83ba23c7925c650e3f3f7d25a5e78dae3ad7c4106f95224f89a2d" => :sierra
    sha256 "e0cc835f1f2258ee8ada70feeb61e7a8ac7d8b85845439a6c108bf192e59f28f" => :el_capitan
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
