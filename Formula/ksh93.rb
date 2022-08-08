class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh#readme"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "e62616caab07b2d090e9ad5e17f058d4b8b8f12b48f44017d9e5d6550dfd5c14"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa0cb874ce9c2fd32eb1e4f252c2da29bdd3f77cb4c24cbfbeb909fb7d5ab4a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f978599539ae75d7e9a5dd7ce9d7b7281faf40b7153dcf6f1939c3ef69283e2"
    sha256 cellar: :any_skip_relocation, monterey:       "97900fff311bd4f45909c3b4053e6256994ab2bc4cc8e4b511b37708e510b7f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "54067840605f77f64136ea8a335754fbc1cda28fd7bdbb4056ba776375bbfdc2"
    sha256 cellar: :any_skip_relocation, catalina:       "4ae7789f2ff61330dcca2e90dd7ec59e54b30d08c28705d5cb6957b721a67922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0b32cb0d301fa08d2b97c1f413893e537fa53dd6a21f3fc508c3ea87fd52d0c"
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
