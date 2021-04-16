class Pup < Formula
  desc "Parse HTML at the command-line"
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
  sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  license "MIT"
  head "https://github.com/EricChiang/pup.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9593a0417aaaa3ae4f906b0996e7cecd5c14f38d6e59c729a7d20f82b5b5db08"
    sha256 cellar: :any_skip_relocation, big_sur:       "adf4c73c13c8066e9aa9c9acae07a6d4f84965dff901919a2f718ef898d1bcb7"
    sha256 cellar: :any_skip_relocation, catalina:      "b543d371442c8a14f8113396523d65f1775f4b61ca55d4b61b859c180eb20777"
    sha256 cellar: :any_skip_relocation, mojave:        "baeef002d46ed4c9872242419ed991b9d9f26d8e5b296f54b2ffb9e1e6bcfc84"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f470de75187b994ef9612c5404dc7622a356c8ee6af21f6b2549b5d7c5d88d32"
    sha256 cellar: :any_skip_relocation, sierra:        "4ba84cffa7cfd01bd252223055abdf5fd8b6cfc27474131cf313e688ea8eeecf"
    sha256 cellar: :any_skip_relocation, el_capitan:    "a1aa49640871c127c76f4aea6db65487db964a055e2aa4d86ee2d8b7f5dcb561"
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/ericchiang/pup"
    dir.install buildpath.children

    os = "darwin"
    on_linux do
      os = "linux"
    end

    cd dir do
      system "gox", "-arch", "amd64", "-os", os, "./..."
      bin.install "pup_#{os}_amd64" => "pup"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end
