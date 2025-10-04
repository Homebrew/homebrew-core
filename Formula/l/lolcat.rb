class Lolcat < Formula
  desc "Rainbows and unicorns in your console!"
  homepage "https://github.com/busyloop/lolcat"
  url "https://github.com/busyloop/lolcat.git",
      tag:      "v100.0.1",
      revision: "27441adfb51bc16073d65dbef300c8d3d7e86dc7"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f3bdc980020b7f82e1a1e00736a06fcafbb5b51603130a562fcc0edf563051d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5fbed8371f5d94b68f747973aa5c5f2d5fa5a9d0fb7a389d0417af3eac6924e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7951f0c60d29956b4b12ba502297f0fa75210d66ed59a6d4f9819f14579d254d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9525a05daefb242035ef0eebe35f63b4a6fd1c90b8a2d7aaec906d770aa4997"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9525a05daefb242035ef0eebe35f63b4a6fd1c90b8a2d7aaec906d770aa4997"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a910107509f0e2b478d97837822deb1297155bcba4622b696ef19d424382346"
    sha256 cellar: :any_skip_relocation, sonoma:         "7951f0c60d29956b4b12ba502297f0fa75210d66ed59a6d4f9819f14579d254d"
    sha256 cellar: :any_skip_relocation, ventura:        "f9525a05daefb242035ef0eebe35f63b4a6fd1c90b8a2d7aaec906d770aa4997"
    sha256 cellar: :any_skip_relocation, monterey:       "f9525a05daefb242035ef0eebe35f63b4a6fd1c90b8a2d7aaec906d770aa4997"
    sha256 cellar: :any_skip_relocation, big_sur:        "df80796c28d2084b48ee2045954dbb2685eaa46935238b6b2a2cd1f41a546860"
    sha256 cellar: :any_skip_relocation, catalina:       "c0e179d579938e4301f04b4896bb2c234f4b643e53e53cbd4a7f796978d2ea6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5a08e03669527c3536a86119c90576a9b984ec3c772a36f88cab1f16a5d71f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8110115e78f3bcb1aca5f3aee73cb81726e59a1293236a780ce99af733a8f524"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lolcat.gemspec"
    system "gem", "install", "lolcat-#{version}.gem"
    bin.install libexec/"bin/lolcat"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
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
