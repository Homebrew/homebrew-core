class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/2.1.1.tar.gz"
  sha256 "bb27397ee9cb7e0ddf4ff51caf5b0a193d636b7a3c52399684c8c383b41c362a"
  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8749973cea753dbe82a574355a61c4e0a09751dccd4d72b591f006653ed09f53" => :catalina
    sha256 "4e389a4a5dfee27261c46209da85c09d835c8c785924a90b301a55dd66a4cc5e" => :mojave
    sha256 "a4d66a098987dd5d4e622c35f0140e76959358fed25d691882b987a1bac650ee" => :high_sierra
  end

  depends_on "bison" => :build

  uses_from_macos "ruby"

  def install
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
