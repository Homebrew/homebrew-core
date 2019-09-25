class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag      => "v100.0.0",
      :revision => "7d96dcad726a5efa05a45b8729be9b6d851437ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "4732ed711ccd6e3d32c9614daca439dea84644a132f8b3dac3d0a52cd26d3b7d" => :mojave
    sha256 "ca82ef3c4b46099bfd3e2e0ad6290fdcde71286db588b4a66069a762cac947ee" => :high_sierra
    sha256 "ebfb0e8ded22cc1eb717a7ba73087cdb0beb5f0447f6642648a2e864736b9c1b" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lolcat.gemspec"
    system "gem", "install", "lolcat-#{version}.gem"
    bin.install libexec/"bin/lolcat"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
    man6.install "man/lolcat.6"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is
      a test
    EOS

    system bin/"lolcat", "test.txt"
  end
end
