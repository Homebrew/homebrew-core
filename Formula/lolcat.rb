class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag      => "v99.9.69",
      :revision => "692002ad5d5b2b797f4918c21655de4eb88d4349"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6782890a9d544a17aa6a9011474eaefea4f7422915177946e88985619aa2367" => :mojave
    sha256 "5cbddd57ab46ac3d73a43ea5ef6264096910d337c815948ec603211cb5c5455f" => :high_sierra
    sha256 "6ce278781b578837a6e23164c37b6515292a54de586318288795ce16a808d654" => :sierra
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
