class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.17.0.tar.gz"
  sha256 "076b52edf888c01097010ad4299e3b2e7a72b60a41abbc65af364af1ed3c8dbe"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3180f8e0386192548fe0e83d272196082656cef69ad422ba9396c44481fff09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96cbd225f3a8d64bda895c4052b2af3a3e1d5bbe137ba017aa3d4c8127cf9d68"
    sha256 cellar: :any_skip_relocation, monterey:       "f26fc50366590d223ce40eb2ce83cb90102f8b03dde2694e7c058e3fbc22eb6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd84e7d6175e98b4839c009120569ece03b5b98db3f152f97ca05b5ae7169843"
    sha256 cellar: :any_skip_relocation, catalina:       "4e06530634324040a69a9f22018e154febc71467cadf2498806d9ba07b06a1b3"
    sha256 cellar: :any_skip_relocation, mojave:         "1e4faf2a09e9a233275d78ede532a0e757d3f8cc9b0ab152326ff9ea9d244dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e86d04d342629c577c07656417e91d7d9b5896a7e167bfbee4d2990c0b5ee94"
  end

  conflicts_with "go-jsonnet", because: "both install binaries with the same name"

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
