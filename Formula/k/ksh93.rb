class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "a5ea1e493f0343c644e12ff03bc464d682b8e61ec034b8e20e95965f62f0b870"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6b25f714e055c51d1ce2293ef846aa07c46670d283c940de421883bbcd371b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3fc13a75c291e28e40e3464f184c548690e2fa0842f06e99c13fa200cd36f3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c116df90fbb33260470ea0d4ab610373845d252b0a6c19a32f8f86fa87abb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4a7f851a0b19462d3da1c32014cc7d239a31f3ab652ecc86165c349e16e3d23"
    sha256 cellar: :any_skip_relocation, sonoma:         "d523eac85ec37f505f2886736fd2542245104c74f11e08a5b7d589afec6a46d5"
    sha256 cellar: :any_skip_relocation, ventura:        "9c711e85c2aac9cd02cd40e20d4f6bec6db6edccf1306b488ff1f18dec4e47c2"
    sha256 cellar: :any_skip_relocation, monterey:       "42f23778ca66202d1274c0fb02ce382d962780f3fdfc2a4c7246cb7b2f64a8e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "37a3d61e3e6dee0a2689a682dca040056724f2329b8637b3bd8aebfcd2c774e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3cca5cdebc4843b7f8ccc871e8f2375ae6b0cb7ce637099d9a0bb1245fc348"
  end

  def install
    system "bin/package", "verbose", "make"
    system "bin/package", "verbose", "install", prefix
    %w[ksh93 rksh rksh93].each do |alt|
      bin.install_symlink "ksh" => alt
      man1.install_symlink "ksh.1" => "#{alt}.1"
    end
    doc.install "ANNOUNCE"
    doc.install %w[COMPATIBILITY README RELEASE TYPES].map { |f| "src/cmd/ksh93/#{f}" }
  end

  test do
    system "#{bin}/ksh93 -c 'A=$(((1./3)+(2./3)));test $A -eq 1'"
  end
end
