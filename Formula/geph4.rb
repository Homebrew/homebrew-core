class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.8.7.tar.gz"
  sha256 "042e3cc12e4043635a923f0198a060691253bc66db1fe2714599768e9c0972ce"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bc9846d8fdfb573d9621bfa1336ead0c085d56d6e2e346296f8c5f3cef900d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79dc3fe8743de17d2730c1bdf20269c33668b42f04a5aae34d6dec684da2772f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "337a5cdbd0b317cb66c9e1f2d423082ccdb021dd34429d2ce90ba000b5591d19"
    sha256 cellar: :any_skip_relocation, ventura:        "6ef350d9d113bb1b2a15853d795513e4d27e177a00edbd61660c3613e2c092f1"
    sha256 cellar: :any_skip_relocation, monterey:       "96dbbbb25d80b4b1850f31a4ec6d717ba396cf31bfe8e4b45d0a0540f0007abb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed2ddf02c28e6509388b3d7e2bfbbfed9db8e908cf306c695cfae44a6322db5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5b59f4e66282b8d6f50054f8efef8622e79a1ab732b3c8138927acc9d7bd53"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
