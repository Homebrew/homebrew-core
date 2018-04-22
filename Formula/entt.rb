class Entt < Formula
  desc "Fast and reliable entity-component system and much more"
  homepage "https://skypjack.github.io/entt/"
  url "https://github.com/skypjack/entt/archive/v2.5.0.tar.gz"
  sha256 "6246501c6589eba9832538c47a23a239eaa1066c77471cae7d79e741141ade82"

  depends_on "cmake" => :test

  def install
    include.install "src/entt"

    # bin.install "." doesn't work
    
    bin.install ".travis.yml"
    bin.install "appveyor.yml"
    bin.install "AUTHORS"
    bin.install "build"
    bin.install "cmake"
    bin.install "CMakeLists.txt"
    bin.install "deps"
    bin.install "docs"
    bin.install "LICENSE"
    bin.install "README.md"
    bin.install "src"
    bin.install "test"
    bin.install "TODO"
  end

  test do
    system "cp", "-rpX", "#{bin}", testpath
    cd "bin"
    cd "build"
    system "cmake", ".."
    system "make"
    system "make", "test"
  end
end
