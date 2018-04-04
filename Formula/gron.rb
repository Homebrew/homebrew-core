require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.5.2.tar.gz"
  sha256 "3320bdf238833b1bb8b96bdb7f1b1f662b595d00af3aaaa35653a98a9b8ecad6"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cbf2a703e65aef054bc0b6d463dea41c76286059fea6b2793b41340b49a7155" => :high_sierra
    sha256 "1bea780ffc0ce98ad4ecefa97669742d0b59431ee1330b174f0063d8864cc256" => :sierra
    sha256 "8f0980ba78395569da69c78262001440aaeb9c643724dc22a211bbcc3816b68e" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "507f6050b8568533fb3f5504de8e5205fa62a114"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "75a6de4340e59be95f0884b9cebdda246e0fdf40"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "816c9085562cd7ee03e7f8188a1cfd942858cded"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tomnomnom").mkpath
    ln_s buildpath, buildpath/"src/github.com/tomnomnom/gron"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gron"
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
