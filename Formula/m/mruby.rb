class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/refs/tags/3.3.0.tar.gz"
  sha256 "53088367e3d7657eb722ddfacb938f74aed1f8538b3717fe0b6eb8f58402af65"
  license "MIT"
  head "https://github.com/mruby/mruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c4d17eb9265f8be0618b73de413ef2060619e8336557b1a296de86a46af0dcd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c9cda4eea867a03f33cd61efb68484c5e0530fe644e38dbb87bc95cec0808ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fd6ddf89b8e721aee5370d3af42e119f55eb83d108b370f6be92442b4b93a03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a3ced6e688ca7201054a3791dfaeb247a720381197785448884d070de5b5a3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "afc8957270619d043b8cc9a1cad20c2a44f87c7d46243a1837445ff2126b8dc2"
    sha256 cellar: :any_skip_relocation, ventura:        "f0bca252cf800449d7fbcf51b77c531a20555b23a559a8f71c35fe3e8e6ecc19"
    sha256 cellar: :any_skip_relocation, monterey:       "c2492155224f16b0777a2e726755806ffff1d810bdcf9a3b858c604a68d6e423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9e941627463809125660387bdb9ecf7836236765014146f22bb5a291dbd48eb"
  end

  depends_on "bison" => :build
  uses_from_macos "ruby" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    cp "build_config/default.rb", buildpath/"homebrew.rb"
    inreplace buildpath/"homebrew.rb",
      "conf.gembox 'default'",
      "conf.gembox 'full-core'"
    ENV["MRUBY_CONFIG"] = buildpath/"homebrew.rb"

    system "make"

    cd "build/host/" do
      lib.install Dir["lib/*.a"]
      prefix.install %w[bin mrbgems mrblib]
    end

    prefix.install "include"
  end

  test do
    system bin/"mruby", "-e", "true"
  end
end
