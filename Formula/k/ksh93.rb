class Ksh93 < Formula
  desc "KornShell, ksh93"
  homepage "https://github.com/ksh93/ksh"
  url "https://github.com/ksh93/ksh/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "b46565045d0eb376d3e6448be6dbc214af454efc405d527f92cb81c244106c8e"
  license "EPL-2.0"
  head "https://github.com/ksh93/ksh.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da09a653036fab17064360cfc16c7b08010742a4a63513cc7bc79084fca56a9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b64ad379ff18a29da5db2b64e6f4bc9a66c20e34cb284a3f003ac366f42614ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbf0ec44ac74fb3ef30ea4f29b82eb5597cb7194f0e0ffe661aed0f4e9dbb86"
    sha256 cellar: :any_skip_relocation, sonoma:         "7153cd1fdab030384bfe7cb4881b2c503793ee5ab977ae7b65f08daddd8d795e"
    sha256 cellar: :any_skip_relocation, ventura:        "5955a0e9881005b0cf8363763cb3beeb1f3d7b9bcc7c81e9ef1d7e52da2b777d"
    sha256 cellar: :any_skip_relocation, monterey:       "ef891b04516323cfa5ec0deb740c845a9c31473c8f9ecb55300e0f8320e9963b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f68aab08050e38f79a60f6ff945a6c33005555f4eaab952bf6d763c1ae39af8e"
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
