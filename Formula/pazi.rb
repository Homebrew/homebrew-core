class Pazi < Formula
  desc "Replacement for autojump, z, fasd, j"
  homepage "https://github.com/euank/pazi"
  url "https://github.com/euank/pazi/archive/v0.4.1.tar.gz"
  sha256 "f513561451b29fed6d4eb3387524df597b5811cd7744eac77d96e368022b6adc"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end
end
