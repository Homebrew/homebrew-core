class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/refs/tags/v1.25.tar.gz"
  sha256 "64cb194bbf08536320d0f4c24ef9524fdf486f579147cacdb0b6dc0afc1134e2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5915cb9fd5390ee5cba9caf9f991b03c837756af3c24a292b202ffe7ad1f9c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7016b0b4b949f29f28f6184c6954c072196c5d97a35fdf113b23be20ee8546e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f698ff3ffaef1601e4ba82581ebb94d28cf9cb7a5bbc4e3c1034ad0e8da13f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe228337f5d9019509b79924ec03bf73e8c567d35801ba004d203855ebf0ec99"
    sha256 cellar: :any_skip_relocation, sonoma:        "e42db1091864a2e65757b17b5ff2777912b98b43de30f9b3c9add5b60885dfbe"
    sha256 cellar: :any_skip_relocation, ventura:       "91422811ec55ebdb10ac1763fcb75da19723767491b5fa5988b4e7e2d5c085e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c6b48da3ddc88e3ff65484755edaa3d5951ebbbf5ff07eb48f7c17ad43dc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18782f87199e7dbcc1470c2c13a6bd0d79bcf0dca59d60f75816c77a9479ac97"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"powerline-go"
  end
end
