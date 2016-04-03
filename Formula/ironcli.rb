require "language/go"

class Ironcli < Formula
  desc "CLI for Iron.io services"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.0.22.tar.gz"
  sha256 "af179a2be5d78844f166f09a21c0387bf22ad87b696b31632e1bc81d002a4779"

  head "https://github.com/iron-io/ironcli.git"

  depends_on "go" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/iron-io/ironcli").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/github.com/iron-io/ironcli" do
      system "go", "build", "-o", "iron"
      bin.install "iron"
    end
  end

  test do
    output = shell_output(bin/"iron --version")
    assert_match version.to_s, output
  end
end
