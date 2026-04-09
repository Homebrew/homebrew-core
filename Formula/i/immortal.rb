class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/refs/tags/v0.24.6.tar.gz"
  sha256 "f62b21ba622ffff04acee5bb7606761db3d19f57cbbe666e40fa84674b1ef4bf"
  license "BSD-3-Clause"
  head "https://github.com/immortal/immortal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "10a6fa0a1ead4e1fc693259409819e54a02dc44966e2cd730132a51758c9bf3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5e2bcd1f7d742201f09a81cf4e84f5ed53fd4f0037b642b88911a5dfe791125c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1c3c0aeb30b0928787e93434aeedb259f019550eb26ee06e86a9958c81d632f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1710b0a46b1221d24c2bbcc560ad91c193c3ad630772d7758dd8a7fd26c3cde0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a500f9e9092f1263f8811d0148e63f9aeb2600233827b98ccdc93d99cb95d05"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4e75b4f8c75d8aae9cc0fae052916f1424b36ac6183942d974077191b6079f6"
    sha256 cellar: :any_skip_relocation, ventura:        "bbe372718d137b00ec707786441d1a6ef0df3a472e5c282464358bdbfef8571f"
    sha256 cellar: :any_skip_relocation, monterey:       "ab444396fab083b3938dc87cfae485a1c2eb0fad2b221a5a00a9bccf5a88f62b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a914374c56ca92616514cd687e47b3d0204266abf5166b5eb229a171b1a53b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75184bcc104152d9b8c6d418f09dcde65d93863645794c19a2482278354dd281"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    %w[immortal immortalctl immortaldir].each do |file|
      system "go", "build", *std_go_args(ldflags:, output: bin/file), "cmd/#{file}/main.go"
    end
    man8.install Dir["man/*.8"]
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
