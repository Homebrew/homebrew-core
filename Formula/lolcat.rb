class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag => "v99.9.19",
      :revision => "40692d01733c5d360022a14f08a4415668544f37"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1f5edec2745ef0eff4ab1b40d654af7de06d3999aceef66670babfc66dea62d" => :mojave
    sha256 "d240127af1150e214e42b97f1f2c5de9f69cc1e6227ade0afa4bb199136a5d09" => :high_sierra
    sha256 "425023804e93bf8d8d5493cae02fae225c6092b659297d7d7f2186a0f7de90fc" => :sierra
    sha256 "0651fd564ed9ced11b35475a9b3fdbbf850e95b312684c8297800ba7f56d4e6f" => :el_capitan
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
