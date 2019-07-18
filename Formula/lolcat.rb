class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      :tag      => "v99.9.99",
      :revision => "2074d47238520f44931bd0204947f6acdc489f7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a80143a72192e7deb0ac935b9915bcb702aaa7902eac2d35fbe307562c9e2537" => :mojave
    sha256 "6c49fea808082b581f45e7c09d8f8623cb35bf2d8a11e9f7f4a694352f94a1d2" => :high_sierra
    sha256 "23e4f4e393c138057234c7c281dd4bbdbc554a3cd4afdf43d976a92330e44825" => :sierra
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
