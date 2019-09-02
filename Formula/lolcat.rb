class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag      => "v100.0.0",
      :revision => "7d96dcad726a5efa05a45b8729be9b6d851437ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "15cbe2be50b9d21d6876528e771a0d91dc66e5e970b1f128025f2a53fc134c56" => :mojave
    sha256 "a5dc24837ef3c7f374d8e005b1a0a152eecdb723289b64bc512fe7a9b081cfe9" => :high_sierra
    sha256 "bb74410996733b99dd265124e5a4868047650b68784024f78e23b73d4396b39c" => :sierra
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
