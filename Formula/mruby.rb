class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/3.1.0.tar.gz"
  sha256 "64ce0a967028a1a913d3dfc8d3f33b295332ab73be6f68e96d0f675f18c79ca8"
  license "MIT"
  head "https://github.com/mruby/mruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cb112f19c066a09881ee34b868b50132d64950b93851ed4349a4b8be3079f21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da37228c833501ecd4e2830808a9928990ae90a9d67e67966115350b5d1d6419"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "904cbd4a3b0c8db16f32988251c3528eef681bdd65673a73204fc1d57eba070e"
    sha256 cellar: :any_skip_relocation, ventura:        "800e309bacd906e6e39ad7c4289cb052bddf122a49eac8a5097315bfa567028f"
    sha256 cellar: :any_skip_relocation, monterey:       "bc0c23c86c20dcc9589e6c19d48ecc94c6fb460443cd0abd29ce8f3ed3f13fc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b16ebd289ab95b7e44f82720069a7c7419dbff2843a3f901ceb296ad314c5a8"
    sha256 cellar: :any_skip_relocation, catalina:       "e0d4cc5aa850d3b5ba19b9373a553c6a7f817f3bd60e2c2b321051cf87368802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb7c46340717e9753faa4ddfa228a47534cb96868abbbf8df9ee28c6cffc91f"
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
