require "language/go"

class Gherkinize < Formula
  desc "Utility command-line for Gherkin"
  homepage "https://github.com/wesovilabs/gherkinize"
  url "https://github.com/wesovilabs/gherkinize/archive/0.0.1.tar.gz"
  sha256 "9a6c96ad54afe73e54c0e7a88abc8ab5ee2e71d7ad7c484cd82b4731923fbd5d"
  head "https://github.com/wesovilabs/gherkinize"

  bottle do
   cellar :any_skip_relocation
   sha256 "7da053cb4f0a73f55dc0cfaeea6628422e214e29c76a3f82c6ebe58faa2fe659" => :sierra
   sha256 "2499eb9e86e59b87640cc93fe8270be64cb1b5ce2a7e5a8d5a0bdcf69e68f054" => :el_capitan
   sha256 "4d781dd4d6bf9b3217d5d197b987583392ba8b6a4abc539720360041779889aa" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "0bdeddeeb0f650497d603c4ad7b20cfe685682f6"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "bbd5bb678321a0d6e58f1099321dfa73391c1b6f"
  end


  def install
    prefix.install Dir["dist/*"]
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/wesovilabs").mkpath
    ln_sf buildpath, buildpath/"src/github.com/wesovilabs/gherkinize"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gherkinize"
  end


  test do
    system "false"
  end

end
