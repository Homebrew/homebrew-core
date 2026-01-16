class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "f26b2af87c03e30139e6a509ef9512203f4e5647f3225b969b112841a9967087"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0563e808fedace771b34dc5be651e242898101d1ba16e5af2d93fc9776dc9d45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac8d147591dcc68329b42238cc2363f05fda1533e3e897fd0d2d67c830f6ac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b575648a9003e0a7479ce49a0224cfb1e9f1d9e492f7a5b050ec096375a5135"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6c6ade21d0fe28b3408b166d29ab5f6d16435f9dc4c8700fe6a7c490816009f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c43e42fd31143a4e0f008a2620e092b0a431b0fe0c68c5adc72acc975859cb1"
    sha256 cellar: :any_skip_relocation, ventura:       "6c6cc4ae173a335eda1f921c2f37dc34bb7b5a3cbba6b77c32f296ba5cd54be2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "483edc63ab9cf31614e368777afccc1934660e5e0b72b801e23fd869ae8133ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dabedc2a620cb0966fcf79c27b6135366a02fc7f37f3413c7cb65df0eec15644"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/2048 test")
    assert_match "All 13 tests executed successfully", output
  end
end
