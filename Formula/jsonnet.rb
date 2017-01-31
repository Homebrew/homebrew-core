class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.9.2.tar.gz"
  sha256 "bf0006ddd1fb3c77faae356e6e83bfa4a92bcd9eef4723b5807c77a09e7ec97f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f959b480d68ce4bd0d9d600443bfdaf7c8cb256496b96961fc4ba04023b43352" => :sierra
    sha256 "47d34648073461a25c948e8456a3b74efc5c799a45d170ea7699028e1e3031c1" => :el_capitan
    sha256 "58c6c64fd877069c911b1e9bb70c9ce7293e5469f725654495834e1e78ced231" => :yosemite
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    (testpath/"example.jsonnet").write <<-EOS
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
        "name" => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name" => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
