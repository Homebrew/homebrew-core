class Mruby < Formula
  desc "Lightweight implementation of the Ruby language"
  homepage "https://mruby.org/"
  url "https://github.com/mruby/mruby/archive/2.1.2.tar.gz"
  sha256 "4dc0017e36d15e81dc85953afb2a643ba2571574748db0d8ede002cefbba053b"
  license "MIT"
  head "https://github.com/mruby/mruby.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1d5fd18c921cf19742a2c484f472d04b41fe84297c6c193ffc932cbc6c375df" => :big_sur
    sha256 "e46379c5d7600c8783732c5a4a93b9c3ce26370865e34f5b1f4c6459d2e8d94e" => :arm64_big_sur
    sha256 "b6a638c04a991a249a737d0ad0d9f7fac31d35a7b2fd3c8507304e68f13bc983" => :catalina
    sha256 "1f31eadc8801f65d42e2cfec43cda336324daf86978529dfc76338e6b094b16c" => :mojave
    sha256 "5b5dca177d9fdd6a2b543c9aeb2117e0d112d1578fadbb709d8565d83b21d6a7" => :high_sierra
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
