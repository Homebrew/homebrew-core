class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://github.com/gtownsend/icon/archive/v9.5.22c.tar.gz"
  version "9.5.22c"
  sha256 "d3f9fd75994cfc7419c6ed1d872d0cc334dab3e20f6494776abd48b7cda43022"
  license :public_domain

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24aba1971d25714f64ec8939e0793ebcff45286d9ae7b23073f566c8080b339"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6701a8396cad967be7e087dac192facd994d80bce11bad854fe73116bb6d7ac"
    sha256 cellar: :any_skip_relocation, monterey:       "1bb00ca4ceb6efe40456a337a97b9b5a31378f129b207efc9a50ec9dc9aeb281"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9607ac39be00a7835497d3f9e4d92b10898516cf1f62b03604e6d6d819cda07"
    sha256 cellar: :any_skip_relocation, catalina:       "3d1a78a9a71385946f1a7275d18bd64acc89d8297787c39c62b337f6359df968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6336e970339edbf3b7f1ada10f2656406f962c2931ae96b33647e4a31191fe10"
  end

  def install
    ENV.deparallelize
    target = if OS.mac?
      "posix"
    else
      "linux"
    end
    system "make", "Configure", "name=#{target}"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    args = "'procedure main(); writes(\"Hello, World!\"); end'"
    output = shell_output("#{bin}/icon -P #{args}")
    assert_equal "Hello, World!", output
  end
end
