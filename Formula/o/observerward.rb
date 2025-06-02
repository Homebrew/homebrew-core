class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://emo-crab.github.io/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.5.15.tar.gz"
  sha256 "c7c6b546f411c7fc05c72f81e1a78a42337b628ea6ad555f93f882c6f5256708"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a91d718b3fed1b3e8eafacd6ed00d7f785ee44df5afd77617f711275d127cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1225c14ac4d89b0f6d98e32b99bc8a49198f402ea52fe530615b39e3666f8b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09122df4ec6181ea8327efdf7828423082617cec80d82b874857fa26e5cd0ad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "47e0c202ce6d9035a2628bebec2ad98c1ea9eeb51a075967ba16e028e8ef4e5a"
    sha256 cellar: :any_skip_relocation, ventura:       "c18b353c57bc5d4d088d3ef0c6bf168a942036e0ae0896436acfe4d9c41fa2df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1730c67652acef23a72664f496516bdc199f47008a75d5c373edfae25914619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16254e5e8789333392aefd58d3fcd2d6391d14d94aaf73ceeba71aaed67a6523"
  end

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
