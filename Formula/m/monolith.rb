class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "1afafc94ba693597f591206938e998fcf2c78fd6695e7dfd8c19e91061f7b44a"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d1266667cffd60fc5ce4ba4e8c08ae6b776f4bd58be50b920c51f658dd4c42a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92826aa3a7f4ca6eac24d7c1b1aee3fd75b3502338cf8c284c99613364d373e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f84b6ccacd950b953340af3a7b46d743626fb44eac00ea27eee1fc1a87afa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "628d8282e77e55dddf76981418a0f92d6aa96cd01ee7adf0b2874eb8288d7f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "81364ea28028bc6a147edbd0c0613db6baef11078f14555330e438a0e2159e5d"
    sha256 cellar: :any_skip_relocation, ventura:       "e2168d625c8330f2462e1f8c6da8c97db0aa2e42443c6045b194fdd9b885722e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2915bebfb7b5a0a116d1922987969e9be94236917e54c7389a5ee964a20198f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d1a5ae8947717fad4f322fa95c6fe603ea543a07a8188eaab279cf0ea01a56"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
