class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag => "v42.24.1",
      :revision => "9f300c6771906e94624f9370a1b758f5749ec6ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "418b84a736d082079aeca4af6d2446c185e6062c2c1c15647ddd4357e9ea73fa" => :sierra
    sha256 "0bf6b7d10ce44f854e3f81c1392d75ba0e4346a92807fb66b97223b8ccd6ad6d" => :el_capitan
    sha256 "9878b6167975b0ad58868d55f1b36465f9a88910dcf22c119950f3d7203a0d83" => :yosemite
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
