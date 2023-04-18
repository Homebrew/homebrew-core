class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/3.2.0.tar.gz"
  sha256 "3c198e4a31d31fe8524013066fac84a67fe6cd6067d92c25a1c79089744cb608"
  license "MIT"
  head "https://github.com/mruby/mruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2acba472ff63497a1ece0d2dcd12ca60c425a21476b4fa2e3a0c76908f8f080c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cbdd00ccffce8e1a59e9a56ea62fba258772cc8e1688bbcde58b40f95fe579f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d79dd3f3888b4df3248b7d6292597dd282884c33793ba5bc561f1a36eef08534"
    sha256 cellar: :any_skip_relocation, ventura:        "0b1d2434d7488888c52ba9b8bab89c0b2d98afd4d7a213114feae7710c45dcf9"
    sha256 cellar: :any_skip_relocation, monterey:       "242af9158824d0036e0d0823c1315ef3b87a104e8880185f6be2f1859290246e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd7069da7bfc7a0e9ee9ef651cf07f4985d7b3bd80fb309c0eaa02222327d961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6b45547787797cdf50cfc7b259883148e80da624098cd36a01bb59ee011a69"
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
    system "#{bin}/mruby", "-e", "true"
  end
end
