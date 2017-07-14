class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag => "v90.8.8",
      :revision => "d78d039699256d6280583d72117270180b8c1ec9"

  bottle do
    cellar :any_skip_relocation
    sha256 "543a885917eb4ca99f191d640cdb8271f2e9b18530a9a6e6dc577246d22fde52" => :sierra
    sha256 "581dce6a68add5a6506a147fdc3943240c0b80d9c42d8110256a0fed753f728f" => :el_capitan
    sha256 "90275ea5161e9ed964e965d0df6e08e03713a064cd2e117096c325c14c337122" => :yosemite
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
