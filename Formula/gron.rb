require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.5.0.tar.gz"
  sha256 "eb125b7857ba4e6113ceff2a53c38f2cebea8e2ff270f89146e866b11eaaa589"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9671771d3b9265564c7682d7290a203ad891722e887176d20c37526ca8f551f" => :high_sierra
    sha256 "912f8260a07b40a3f71a8f5da4a3c2c052354eb60184503eb99b478d3088324d" => :sierra
    sha256 "c2ec4063402fdf9ecaf03977bd18faa2be5922e4478461a3648773ab0de9df92" => :el_capitan
    sha256 "b40c42cd53fdbab2b94504a67451a99744966734a35bc8f02795fea6568c4d95" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "34e4ee095d12986a2cef5ddb9aeb3b8cfcfea17c"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "ed8eb9e318d7a84ce5915b495b7d35e0cfe7b5a8"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "3a115632dcd687f9c8cd01679c83a06a0e21c1f3"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "0192e84d44af834c3a90c8a17bf670483b91ad5a"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "645ef00459ed84a119197bfb8d8205042c6df63d"
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
