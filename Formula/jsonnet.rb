class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.18.0.tar.gz"
  sha256 "85c240c4740f0c788c4d49f9c9c0942f5a2d1c2ae58b2c71068107bc80a3ced4"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0fcbd957bf1e3fa91a3e7e6f1d1316fb0dfb8aaa72f94ded7d1ab8ac96caf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "deb98f7009d75ce4a9f68464e6d8347c885b5f4de50691d0ab8228e775cc5beb"
    sha256 cellar: :any_skip_relocation, monterey:       "6ed8bac0e7eb061832f680b8305a22b25298730741aebb6e2bbc3cbfba95a19d"
    sha256 cellar: :any_skip_relocation, big_sur:        "087b337943c70e343383517a99ff4013206b8d1fa2c902d4b3c945873fd1e493"
    sha256 cellar: :any_skip_relocation, catalina:       "2455ed01cf6b28b5a6fb7466e6ad3c8d6c64c351aabf1b2cfdc102fc9af421f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35bec7fa0eed3d22933083ba80f5d05ae770e4bbc0b42e549e3a0e8bb770a086"
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
