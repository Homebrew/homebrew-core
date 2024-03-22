class Nerdfix < Formula
  desc "Find/fix obsolete Nerd Font icons"
  homepage "https://github.com/loichyan/nerdfix"
  url "https://github.com/loichyan/nerdfix/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "72e835aeb349495be87e92f74f405b43dac982ec137cfd7e180e72146b6f6fb7"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f54b1925b720fc83c90365b73f20afe041d57a8897ae7a3250e6d45a9f1e3503"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee40bd99dfa454b7300d9cdb5d6596dcbb959d4e63197b8f608d6e1226834bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3790a49ea1ff71d0d4f3ede9d503427bd2969b212383f6551c57f18a56d1a504"
    sha256 cellar: :any_skip_relocation, sonoma:         "4150cf0f61cfe6424b2c8b72a07e5930b0c609822f6f4c5cafbf38bb462b2ad5"
    sha256 cellar: :any_skip_relocation, ventura:        "43c6190ad07d0438b0fd0a33ec4f96d42894cfd13800e5af28de88756f73f4a7"
    sha256 cellar: :any_skip_relocation, monterey:       "9c35567729497a8f2bda16863c5ca6df5905cc989c08bf0c8319d25930385f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c463aee0ef326c902eac2b658966b573e7c3f70afe914c1bfd198dc95f91d87"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    system bin/"nerdfix", "check", "test.txt"
  end
end
