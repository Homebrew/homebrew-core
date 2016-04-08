require "language/go"

class Ironcli < Formula
  desc "CLI for Iron.io services"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.0.22.tar.gz"
  sha256 "af179a2be5d78844f166f09a21c0387bf22ad87b696b31632e1bc81d002a4779"

  head "https://github.com/iron-io/ironcli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6c39cc1dddd6acd8ce735836bb103cea0e90ce14b49453a1bc95515ccd77229" => :el_capitan
    sha256 "9db4f01a3e5910906cdea17bc724a8839eb277e7ce26e4d8b739dbe0917a17c1" => :yosemite
    sha256 "e354874cfff38921a6ef25bcf911637318f89ccf8fd1f07074e55ff393152acf" => :mavericks
  end

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
