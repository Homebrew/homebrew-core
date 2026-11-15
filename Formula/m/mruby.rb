class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/refs/tags/4.0.0.tar.gz"
  sha256 "e2ea271dbed14e9f2b33df773ae447b747dbc242ce2675022c0a57efea85a7b4"
  license "MIT"
  head "https://github.com/mruby/mruby.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94de3bc09ba9d07d0a92e20061f7bc1ea53fa96d31bfc1e4675240e3a60a8240"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a778a666feb1f5d51fd3eb467e60a57a7fef4186493dce030dbc05116982a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13f8a942e4ddc94e887fb1f5189eef6911f91367568a3a9a30052e37d57d90ff"
    sha256 cellar: :any,                 arm64_linux:       "6adf39ec1fcbb5e86597f80c55c15f07627545c8aa3741ac055bf9889928a9a2"
    sha256 cellar: :any,                 x86_64_linux:      "f7a8a6b51af82536ec54e8a94c115267f3522cae02005141f9936c6735ba7dda"
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
      prefix.install %w[bin include mrbgems mrblib]
    end
  end

  test do
    system bin/"mruby", "-e", "true"
  end
end
