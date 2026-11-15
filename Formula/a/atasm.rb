class Atasm < Formula
  desc "Atari MAC/65 compatible assembler for Unix"
  homepage "https://sourceforge.net/projects/atasm/"
  url "https://github.com/CycoPH/atasm/archive/refs/tags/V1.32.tar.gz"
  sha256 "711af3d28b93046471c04afb09b39fffd16ab57f0129bf02a784ff84cf78f9c6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a8df26d09ce0bad968f4d7cbdf046766f8c4745af963aa0708f5c7ad4fb5d36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95bf01730246e601cc9741c8e232eb4d4d3252db1f474a0f0dc85960ae3df0e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "529892d474aa05429b6d4d0a4f350a393d8ea2acd5c8997d9c7a3434d17f954b"
    sha256 cellar: :any,                 arm64_linux:       "42387155834bb447ae443874ce4761b05d5cc46ed4604a1c5db90cd8a59250fc"
    sha256 cellar: :any,                 x86_64_linux:      "c224488d8ec725460db0c092973aa3779c9305a89579d1af1c2d26276713c7b1"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    cd "src" do
      system "make"
      bin.install "atasm"
      inreplace "atasm.1.in", "%%DOCDIR%%", "#{HOMEBREW_PREFIX}/share/doc/atasm"
      man1.install "atasm.1.in" => "atasm.1"
    end
    doc.install "examples", Dir["docs/atasm.*"]
  end

  test do
    cd "#{doc}/examples" do
      system bin/"atasm", "-v", "test.m65", "-o/tmp/test.bin"
    end
  end
end
