class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/refs/tags/4.0.0.tar.gz"
  sha256 "e2ea271dbed14e9f2b33df773ae447b747dbc242ce2675022c0a57efea85a7b4"
  license "MIT"
  head "https://github.com/mruby/mruby.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0a3d3a3f842a842d9cec36a08cdaff6161887ed1c2c222098f0e063c55863ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99b8781738cb0864ef63b328b02f4fad6588b80d3c58728a2d5274129dc40f68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71deb7d31b3334da2c773093bba951513cce8c42a044dcd88b672a031b21ac6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2d49d516e0ab05213fc902be1b1fe6f8c47d2aa7c8f42304643fb8416e8a96e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72df680f25d3bf7b427eaf8cbad7688896f22736c5a33f680d697a906b3aeccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d7f08b13bbe8f0db66ec128ba959cf3555e5929c9643fd46c8aabe385efca7"
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
