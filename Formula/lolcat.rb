class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag      => "v99.9.21",
      :revision => "58d5b5ba6d1d3f70aa72b140ee84034aaab91a9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "936aa4a368904c0366a123a42428aa8876f6b9798fe1ef2844dff0e85861c486" => :mojave
    sha256 "45b78768bd819af7036826373821c1c103b1ba140b9c0acdbea400cdc7e1cb65" => :high_sierra
    sha256 "daffd2e11adf25676c4d00b298c01a9ddc5e18a030249dd85564c006f530e1a7" => :sierra
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
