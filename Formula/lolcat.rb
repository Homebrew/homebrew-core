class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag => "v90.8.8",
      :revision => "d78d039699256d6280583d72117270180b8c1ec9"

  bottle do
    cellar :any_skip_relocation
    sha256 "492e7fe98802675c99f981a57ad9526b248351a9c62ff4c65c92cc91a7ce7d0a" => :sierra
    sha256 "ede0105710e8d64af8998252e978dc4983efa10a234ecdab25b6bd61a8d11a08" => :el_capitan
    sha256 "b338cd33256e246e29f7e3c79b2442d8abb895e10e97e5fb988c7d8dced2ac36" => :yosemite
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lolcat.gemspec"
    system "gem", "install", "lolcat-#{version}.gem"
    bin.install libexec/"bin/lolcat"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      This is
      a test
    EOS

    system bin/"lolcat", "test.txt"
  end
end
