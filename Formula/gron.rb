require "language/go"

class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.5.1.tar.gz"
  sha256 "062462b8b6e884cd5731b0bc870e9a45f450e056f4367acccddb926079686560"
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
        :revision => "5df930a27be2502f99b292b7cc09ebad4d0891f4"
  end

  go_resource "github.com/nwidger/jsoncolor" do
    url "https://github.com/nwidger/jsoncolor.git",
        :revision => "75a6de4340e59be95f0884b9cebdda246e0fdf40"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "e881fd58d78e04cf6d0de1217f8707c8cc2249bc"
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
