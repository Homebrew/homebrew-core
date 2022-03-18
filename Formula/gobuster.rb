class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster.git",
      tag:      "v3.1.0",
      revision: "f5051ed456dc158649bb8bf407889ab0978bf1ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44353288958adfaede89054b42dbac2f20f4cf1968d2c1b7101d3ab140d4eef8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e7f65fbed3896cb3b63eefddd16de3b621a8d72b205d24b8f7abd21379f87e"
    sha256 cellar: :any_skip_relocation, monterey:       "ecbea96dbc4a7889cb9c2cd295d84858b5f332b7d44c12f482450e6e1e10266f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8342b115722243f5c108de8ecdb5aefd20ae5deb884e48732c80595c24897f0d"
    sha256 cellar: :any_skip_relocation, catalina:       "f8f36299b36b59006637dcc7d062614eb209ba82a31f5a67fce789c4d6ef9562"
    sha256 cellar: :any_skip_relocation, mojave:         "16912d38db06501d02cdab6066d1da01129779d958ce142c40018cce30328fc4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "341ce02f5e99ba1bf9cee8d6cbdd150a6e36d8b0fd811ded7a2da8933d877f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493ef7685bc5627b6b382479f3645eda52a36010581e3c9400145775d7da0ca2"
  end

  # Bump to 1.18 on the next release.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"gobuster"
    prefix.install_metafiles
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output
  end
end
