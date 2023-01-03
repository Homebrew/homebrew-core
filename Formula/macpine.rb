class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v0.8.tar.gz"
  sha256 "bd3d1e47acb9cbb29b57fa570817a12cc61b618721113fe356bff6b3a01c3953"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8705f9a058e0d1ab5c9172da384eb53e4bee10004819cc48ffaea4262d383b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c51bd2e0c75193e6a622ee93f316ae56f1decdeae9d09a44122847e366c41625"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de5a2c829c59ff3236ab890fb21f991091199f6a1deaeedcbae5c9ff40ad8b3d"
    sha256 cellar: :any_skip_relocation, ventura:        "5a1516a0093f00b6269ef7fce98c366687f65f087fac6605f84265d11ef62072"
    sha256 cellar: :any_skip_relocation, monterey:       "d30216817bc324ff6fddbdf7aa27d1c029e90ecfb9005894940c4fc1b7446d57"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7482326b2d9a18353152ab96d940c4137ba414005b8099020595b020272268e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089491cccf630e33ad19f8d665dba2aa69ef7d91dbd86c80ea08e292ff114c55"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "NAME OS STATUS SSH PORTS ARCH PID", shell_output("#{bin}/alpine list")
  end
end
