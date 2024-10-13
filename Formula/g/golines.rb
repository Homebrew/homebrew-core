class Golines < Formula
  desc "Golang formatter that fixes long lines"
  homepage "https://github.com/segmentio/golines"
  url "https://github.com/segmentio/golines/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "6f3c462dc707b4441733dbcbef624c61cce829271db64bd994d43e50be95a211"
  license "MIT"
  head "https://github.com/segmentio/golines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8628e4ccb364c54ea775fc8e57e384c069227c877da8e187ab8eea213f2b5dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dc4bef5b399d03b8626c287f69dd1053f67a264745534ed74650b0f5836ed35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71db471b15d2097c568876c4d9bb1e518c464ab5975cc44319b62c1d8019cc82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a66936ba1408201f4a983a97674df7f264d96faa3042eaea5d67e9e9399f243"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f9c40205f9bde8207f3c30d3b0188a68300f10f8bf2cdfce9f1e4c6156edf0e"
    sha256 cellar: :any_skip_relocation, ventura:        "c70ffc9ce915ec300b0ca5320f144b282bf51f63fe5cf9879c75d2cd5adaf815"
    sha256 cellar: :any_skip_relocation, monterey:       "9546e25a342e830eb4a307068167a68b4c5f714b1ae7fb0bc66242dacc72ce48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0fcaa9315813afba851b606dedde377a1083eeea1da796f0467cafd820cbba3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"given.go").write <<~EOS
      package main

      var strings = []string{"foo", "bar", "baz"}
    EOS
    (testpath/"expected.go").write <<~EOS
      package main

      var strings = []string{\n\t"foo",\n\t"bar",\n\t"baz",\n}
    EOS
    assert_equal shell_output("#{bin}/golines --max-len=30 given.go"), (testpath/"expected.go").read
  end
end
