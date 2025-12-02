class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "c7e7c4b215d9d1376c22f4183147debd0ef24aacd772df7311a33678f2119e33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "34bcd82ccf6d8e8699240368b8bb8de6f8f1c5df7acd6b5fb34ac6c3818f7165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b47c77b95e1ad1b3d53ef03ce4f7798d2b3e12da6d1ec809038eeed2d45b06e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b942eed75c111fcdafe3445553e2b8ef861db535dd503f653df91744b9202ccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8537ed041674f1d9418bf57d04af4857a76063454d3721fef418e88c3869b286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "942880050979de965ede2a91030cd3a49bed2a79ae268242e99b9576b2749b07"
    sha256 cellar: :any_skip_relocation, sonoma:         "2be5433dec7eb3fff8181616f7e56545ef8b39e2e103ce92d89b8555db514f56"
    sha256 cellar: :any_skip_relocation, ventura:        "083442858a2c592b845c0a2ad7b54d2ebd576def0bd47b8ba3e761d5efbe428d"
    sha256 cellar: :any_skip_relocation, monterey:       "f552366e174168da76eb245cee3c48b691b342867eddc142404f476bf2777fea"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8ed0416d2bf5805a5563a19e176512265e6a56df9e09566cc7274fc88ef2bd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7be03a27ce9da39007c389b06729a30860a95cf5559b3a29a27089de55dce02"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"genact", "--print-completions")
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
