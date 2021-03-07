class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/3.0.0.tar.gz"
  sha256 "95b798cdd931ef29d388e2b0b267cba4dc469e8722c37d4ef8ee5248bc9075b0"
  license "MIT"
  head "https://github.com/mruby/mruby.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b4efffa2417122f3afbe67c4159d2e0938161d63a1caddbb7886bc8140eea8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a37241df0d1f4a5a6b2d7a52c1bdf3b9487484b3fce1f90ff49994f6e7095c89"
    sha256 cellar: :any_skip_relocation, catalina:      "13b1277f194b5b75b49d14b8ad814dc3ca0b261edf5d3c741bd99236348b47d3"
    sha256 cellar: :any_skip_relocation, mojave:        "f6bee79071bec85f97704d8b3b7f535a8003d07bf8bb0e0ef556f82fdcb3cb81"
  end

  depends_on "bison" => :build

  uses_from_macos "ruby"

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
