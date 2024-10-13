class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.18.1.tar.gz"
  sha256 "06cb38c81f0152670c730e906a27f49b353958fe90dcdf9f90f318785c19977f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ef4734cd2decfa9e8a4c89318920ce3084d53a40b3a00544ced5a9a40795fe2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a893fa52ef390ceeac195fb0e7a0e3ca4bf713da7b846b2b7f01165ab559e271"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b972695a9ccaedde6bdef45e0805fb5e787a6758b17063f7e11539656f74c93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97fa5cb4bbc1a891b1d07d2e1f4a78b26166495c1b8af6d5ccb374cb4ea9d963"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e1e479d98e621ac843b5110c64578cd8fac7422f5ff56267c7938587e23121a"
    sha256 cellar: :any_skip_relocation, ventura:        "087a6733c970d134632c435f4619189de3cf2a430fca80a12bdaaebabf284c32"
    sha256 cellar: :any_skip_relocation, monterey:       "89bcd8f83f0daa3ea424542cc9e1a64e5a5449ebf564ff753d0b93a1e953a55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a4cf445a11cbf0617f8ca0c36da67628a790fd1754b9338ffb895adf8e43db8"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
